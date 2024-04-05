import Foundation

public enum API: String, Sendable {
    case prod = "https://api.getalby.com"
    case dev =  "https://api.regtest.getalby.com"
}

@AlbyActor
class AlbyEnvironment {
    static var current: AlbyEnvironment = .init()
    
    struct Constants {
        static let token = "com.github.sparrowtek.albykit.filename.token"
    }
    
    var api: API?
    var clientID: String?
    var clientSecret: String?
    var redirectURI: String?
    let routerDelegate = AlbyRouterDelegate()
    let authManager = AuthManager()
    weak var delegate: AlbyKitDelegate?
    var tokenRefreshRequired = false
    var codeVerifier: String?
    
    private init() {}
    
    func setup(api: API, clientID: String, clientSecret: String, redirectURI: String) {
        self.api = api
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }
    
    func setTokenRefreshRequired(_ tokenRefreshRequired: Bool) {
        self.tokenRefreshRequired = tokenRefreshRequired
    }
    
    func setDelegate(_ delegate: AlbyKitDelegate?) {
        self.delegate = delegate
    }
}
