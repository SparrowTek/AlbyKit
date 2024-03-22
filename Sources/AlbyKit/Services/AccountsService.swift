import Foundation

public struct AccountsService: Sendable {
    private let router: NetworkRouter<AccountsAPI> = {
        let router = NetworkRouter<AccountsAPI>(decoder: .albyDecoder)
        router.delegate = AlbyEnvironment.current.routerDelegate
        return router
    }()
    
    /// Get value4value information
    /// Scope needed: account:read
    /// Returns the user's Lightning Address and keysend information.
    /// - returns `Keysend` object
    public func getValue4Value() async throws -> Keysend {
        try await router.execute(.value4Value)
    }
    
    /// Get account balance
    /// Scope needed: balance:read
    /// Returns the balance of the user's wallet.
    /// - returns `AccountBalance` object
    public func getAccountBalance() async throws -> AccountBalance {
        try await router.execute(.accountBalance)
    }
    
    /// Get account summary
    /// Scope needed: balance:read
    /// Returns the balance, incoming/outgoing transaction count, boostagram count
    /// - returns `AccountSummary` object
    public func getAccountSummary() async throws -> AccountSummary {
        try await router.execute(.summary)
    }
    
    /// Get personal information
    /// Get the user's e-mail address, display name, avatar, nostr pubkey, and value4value information.
    /// - returns `PersonalInformation` object
    public func getPersonalInformation() async throws -> PersonalInformation {
        try await router.execute(.me)
    }
}

enum AccountsAPI {
    case value4Value
    case accountBalance
    case summary
    case me
}

extension AccountsAPI: EndpointType {
    public var baseURL: URL {
        guard let environmentURL = AlbyEnvironment.current.api else { fatalError("You must call the AlbyKit Setup method before using AlbyKit") }
        guard let url = URL(string: environmentURL.rawValue) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .value4Value: "/user/value4value"
        case .accountBalance: "/balance"
        case .summary: "/user/summary"
        case .me: "/user/me"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .value4Value, .accountBalance, .summary, .me: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .value4Value, .accountBalance, .summary, .me: .request
        }
    }
    
    var headers: HTTPHeaders? {
        get async {
            guard let accessToken = await AlbyEnvironment.current.delegate?.getAccessToken() else { return nil }
            
            return switch self {
            case .value4Value, .accountBalance, .summary, .me:
                ["Authorization" : "Bearer \(accessToken)"]
            }
        }
    }
}


