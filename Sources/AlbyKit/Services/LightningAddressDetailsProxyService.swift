import Foundation

@AlbyActor
public struct LightningAddressDetailsProxyService {
    private let router = NetworkRouter<LightningAddressDetailsProxyAPI>(decoder: .albyDecoder)
    
    public init() {}
    
    /// Get Info
    /// Returns the passed lightning address' LNURLp, Keysend and Nostr information.
    /// GET https://api.getalby.com/lnurl/lightning-address-details
    /// Returns the Lightning Address' LNURLp, Keysend and Nostr information.
    public func getInfo(for lightningAddress: String) async throws -> LightningAddressDetails {
        try await router.execute(.getInfo(lightningAddress: lightningAddress))
    }
    
    /// Request Invoice
    /// Creates a new invoice to receive lightning payments.
    /// GET https://api.getalby.com/lnurl/generate-invoice
    /// Creates a new invoice to receive lightning payments.
    /// Please refer to [https://github.com/lnurl/luds](https://github.com/lnurl/luds) (LUD-06, LUD-12, LUD-18) and any other LUD that extends the functionality of LUD-06 for more information on what parameters can be passed.
    public func requestInvoice(lightningAddress: String, amount: String, comment: String?) async throws -> GeneratedInvoice {
        try await router.execute(.requestInvoice(lightningAddress: lightningAddress, amount: amount, comment: comment))
    }
}

enum LightningAddressDetailsProxyAPI {
    case getInfo(lightningAddress: String)
    case requestInvoice(lightningAddress: String, amount: String, comment: String?)
}

extension LightningAddressDetailsProxyAPI: EndpointType {
    public var baseURL: URL {
        get async {
            guard let environmentURL = await AlbyEnvironment.current.api else { fatalError("You must call the AlbyKit Setup method before using AlbyKit") }
            guard let url = URL(string: environmentURL.rawValue) else { fatalError("baseURL not configured.") }
            return url
        }
    }
    
    var path: String {
        switch self {
        case .getInfo: "/lnurl/lightning-address-details"
        case .requestInvoice: "/lnurl/generate-invoice"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getInfo, .requestInvoice: .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getInfo(let lightningAddress):
                return .requestParameters(encoding: .urlEncoding(parameters: ["ln" : lightningAddress]))
        case .requestInvoice(let lightningAddress, let amount, let comment):
            var parameters: Parameters = [:]
            append(lightningAddress, toParameters: &parameters, withKey: "ln]")
            append(amount, toParameters: &parameters, withKey: "amount")
            append(comment, toParameters: &parameters, withKey: "comment")
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}


