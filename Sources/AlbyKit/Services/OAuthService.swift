import Foundation
import SafariServices
import CryptoKit

public enum OAuthServiceError: Error {
    case badURL
    case clientIDNotSet
    case redirectURLNotSet
    case generateCodeChallenge
    case codeVerifier
}

@AlbyActor
public class OAuthService: NSObject {
    private let router = NetworkRouter<OAtuhAPI>(decoder: .albyDecoder)
    private var codeVerifier: String?
    
    /// Get a `SFSafariViewController` to authenticate Alby
    @MainActor
    public func getAuthCodeWithUIKit(preferredControlerTintColor: UIColor? = nil, preferredBarTintColor: UIColor? = nil, withScopes scopes: [Scopes]) async throws -> SFSafariViewController {
        let url = try await getAuthURL(withScopes: scopes)
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        safariViewController.preferredBarTintColor = preferredBarTintColor
        safariViewController.preferredControlTintColor = preferredControlerTintColor
        return safariViewController
    }
    
    /// Get a SafariView - a swiftUI `UIViewControllerRepresentable` that wraps `SFSafariViewController` and will allow Alby authentication
    public func getAuthCodeWithSwiftUI(preferredControlerTintColor: UIColor? = nil, preferredBarTintColor: UIColor? = nil, withScopes scopes: [Scopes]) throws -> SafariView {
        let url = try getAuthURL(withScopes: scopes)
        let safariView = SafariView(url: url, delegate: self, preferredControlerTintColor: preferredControlerTintColor, preferredBarTintColor: preferredBarTintColor)
        return safariView
    }
    
    /// Get the Alby authentication URL that must be opened in Safari
    public func getAuthURL(withScopes scopes: [Scopes]) throws -> URL {
        guard let clientID = AlbyEnvironment.current.clientID else { throw OAuthServiceError.clientIDNotSet }
        guard let redirectURI = AlbyEnvironment.current.redirectURI else { throw OAuthServiceError.redirectURLNotSet }
        let urlPrefix = AlbyEnvironment.current.api == .prod ? "https://getalby.com" : "https://app.regtest.getalby.com"
        let codeVerifier = PKCECodeGenerator.generateCodeVerifier()
        self.codeVerifier = codeVerifier
        let codeChallenge = try PKCECodeGenerator.generateCodeChallenge(from: codeVerifier)
        guard let url = URL(string: "\(urlPrefix)/oauth?client_id=\(clientID)&code_challenge=\(codeChallenge)&code_challenge_method=S256&response_type=code&redirect_uri=\(redirectURI)&scope=\(combineScopesString(scopes))") else { throw OAuthServiceError.badURL }
        return url
    }
    
    private func combineScopesString(_ scopes: [Scopes]) -> String {
        var scopeString = ""
        
        for scope in scopes {
            scopeString += scope.rawValue
            
            if scope != scopes.last {
                scopeString.append(" ")
            }
        }
        
        return scopeString
    }
    
    /// Requests the OAuth token
    public func requestAccessToken(code: String) async throws -> Token {
        guard let codeVerifier else { throw OAuthServiceError.codeVerifier }
        guard let redirectURI = AlbyEnvironment.current.redirectURI else { throw OAuthServiceError.redirectURLNotSet }
        let token: Token = try await router.execute(.requestToken(code: code, codeVerifier: codeVerifier, redirectURI: redirectURI), shouldCheckToken: false)
        try storeTokenMetadata(for: token)
        return token
    }
    
    /// Refreshes the OAuth token
    public func refreshAccessToken() async throws {
        let token: Token = try await router.execute(.refreshToken, shouldCheckToken: false)
        try storeTokenMetadata(for: token)
        await AlbyEnvironment.current.delegate?.tokenUpdated(token)
    }
    
    private func storeTokenMetadata(for token: Token) throws {
        let tokenMetadata = TokenMetadata(expiresIn: token.expiresIn, scope: token.scope, tokenType: token.tokenType, createdAt: .now)
        try Storage.remove(AlbyEnvironment.Constants.token, from: .documents)
        try Storage.store(tokenMetadata, to: .documents, as: AlbyEnvironment.Constants.token)
    }
}

extension OAuthService: SFSafariViewControllerDelegate {
    nonisolated
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // NO-OP
    }
}

fileprivate struct PKCECodeGenerator {
    /// Generate a random string of 64 characters
    static func generateCodeVerifier() -> String {
        var buffer = [UInt8](repeating: 0, count: 64)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        return Data(buffer).base64URLEncodedString()
    }
    
    /// Generate SHA-256 hash of the code verifier
    /// Convert to URL-safe base64 without padding
    static func generateCodeChallenge(from verifier: String) throws -> String {
        guard let data = verifier.data(using: .utf8) else { throw OAuthServiceError.generateCodeChallenge }
        let dataHash = SHA256.hash(data: data)
        return Data(dataHash).base64URLEncodedString()
    }
}

fileprivate extension Data {
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}

enum OAtuhAPI {
    case requestToken(code: String, codeVerifier: String, redirectURI: String)
    case refreshToken
}

extension OAtuhAPI: EndpointType {
    public var baseURL: URL {
        get async {
            guard let environmentURL = await AlbyEnvironment.current.api else { fatalError("You must call the AlbyKit Setup method before using AlbyKit") }
            guard let url = URL(string: environmentURL.rawValue) else { fatalError("baseURL not configured.") }
            return url
        }
    }
    
    var path: String {
        switch self {
        case .requestToken, .refreshToken: "/oauth/token"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .requestToken, .refreshToken:
            return .post
        }
    }
    
    var task: HTTPTask {
        get async {
            switch self {
            case .requestToken(let code, let codeVerifier, let redirectURI):
                let parameters: Parameters = [
                    "code" : code,
                    "code_verifier" : codeVerifier,
                    "grant_type" : "authorization_code",
                    "redirect_uri" : redirectURI,
                ]
                
                return .requestParameters(encoding: .urlEncoding(parameters: parameters))
            case .refreshToken:
                let parameters: Parameters = [
                    "refresh_token" : await AlbyEnvironment.current.delegate?.getFreshToken() ?? "",
                    "grant_type" : "refresh_token",
                ]
                
                return .requestParameters(encoding: .urlEncoding(parameters: parameters))
            }
        }
    }
    
    var headers: HTTPHeaders? {
        get async {
            guard let clientID = await AlbyEnvironment.current.clientID, let clientSecret = await AlbyEnvironment.current.clientSecret else { return nil }
            let credentialString = "\(clientID):\(clientSecret)"
            guard let data = credentialString.data(using: .utf8) else { return nil }
            let base64 = data.base64EncodedString()
            
            return switch self {
            case .requestToken:
                [
                    "Content-Type" : "application/x-www-form-urlencoded",
                    "Authorization" : "Basic \(base64)",
                ]
            case .refreshToken:
                [
                    "Content-Type" : "multipart/form-data",
                    "Authorization" : "Basic \(base64)",
                ]
            }
        }
    }
}
