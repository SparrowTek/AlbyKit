import Foundation
import SafariServices

public enum OAuthServiceError: Error {
    case badURL
    case clientIDNotSet
    case redirectURLNotSet
}

public class OAuthService: NSObject {
    private let router = NetworkRouter<OAtuhAPI>(decoder: .albyDecoder)
    
    public func authenticateWithUIKit(preferredControlerTintColor: UIColor? = nil, preferredBarTintColor: UIColor? = nil, withScopes scopes: [Scopes]) throws -> SFSafariViewController {
        let url = try buildAuthURL(withScopes: scopes)
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        safariViewController.preferredBarTintColor = preferredBarTintColor
        safariViewController.preferredControlTintColor = preferredControlerTintColor
        return safariViewController
    }
    
    public func authenticateWithSwiftUI(preferredControlerTintColor: UIColor? = nil, preferredBarTintColor: UIColor? = nil, withScopes scopes: [Scopes]) throws -> SafariView {
        let url = try buildAuthURL(withScopes: scopes)
        let safariView = SafariView(url: url, delegate: self, preferredControlerTintColor: preferredControlerTintColor, preferredBarTintColor: preferredBarTintColor)
        return safariView
    }
    
    private func buildAuthURL(withScopes scopes: [Scopes]) throws -> URL {
        guard let clientID = AlbyEnvironment.current.clientID else { throw OAuthServiceError.clientIDNotSet }
        guard let redirectURI = AlbyEnvironment.current.redirectURI else { throw OAuthServiceError.redirectURLNotSet }
        guard let url = URL(string: "https://getalby.com/oauth?client_id=\(clientID)&response_type=code&redirect_uri=\(redirectURI)&scope=\(combineScopesString(scopes))") else { throw OAuthServiceError.badURL }
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
    
    /// Refreshes the OAuth token
    public func refreshToken() async throws {
        let token: String = try await router.execute(.token)
        print("TOKEN: \(token)")
        // TODO: Save token in keychain
    }
}

extension OAuthService: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // NO-OP
    }
}

enum OAtuhAPI {
    case token
}

extension OAtuhAPI: EndpointType {
    public var baseURL: URL {
        guard let environmentURL = AlbyEnvironment.current.api else { fatalError("You must call the AlbyKit Setup method before using AlbyKit") }
        guard let url = URL(string: environmentURL.rawValue) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .token: "/oauth/token"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .token:
                return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .token:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
