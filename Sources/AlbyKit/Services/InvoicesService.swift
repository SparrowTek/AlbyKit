import Foundation

public struct InvoicesService: Sendable {
    private let router: NetworkRouter<InvoicesAPI> = {
        let router = NetworkRouter<InvoicesAPI>(decoder: .albyDecoder)
        router .delegate = AlbyEnvironment.current.routerDelegate
        return router
    }()
    
    /// Create an invoice
    /// Scope needed: invoices:create
    /// Creates a new invoice to receive lightning payments.
    /// - returns a `CreatedInvoice` object
    public func create(invoice: InvoiceUploadModel) async throws -> CreatedInvoice {
        try await router.execute(.createInvoice(invoice))
    }
    
    /// Get incoming invoice history
    /// Scope needed: invoices:read
    /// Lists all settled incoming invoices, including boostagram and LNURL metadata.
    /// - returns an array of `Invoice` objects
    public func getIncomingInvoiceHistory(with uploadModel: InvoiceHistoryUploadModel) async throws -> [Invoice] {
        try await router.execute(.incomingInvoiceHistory(uploadModel))
    }
    
    /// Get outgoing invoice history
    /// Scope needed: transactions:read
    /// Lists all settled outgoing invoices, including boostagrams information.
    /// - returns an array of `Invoice` objects
    public func getOutgoingInvoiceHistory(with uploadModel: InvoiceHistoryUploadModel) async throws -> [Invoice] {
        try await router.execute(.outgoingInvoiceHistory(uploadModel))
    }
    
    /// Get all invoice history
    /// Scope needed: invoices:read
    /// Combination of incoming and outgoing invoice histories. Possible query parameters are the same as above.
    /// - returns an array of `Invoice` objects
    public func getAllInvoiceHistory(with uploadModel: InvoiceHistoryUploadModel) async throws -> [Invoice] {
        try await router.execute(.allInvoiceHistory(uploadModel))
    }
    
    /// Get a specific invoice
    /// Scope needed: invoices:read
    /// Get details about specific invoice. Can be both incoming or outgoing.
    /// ## Unsettled invoices can only be retrieved if they were created through the Alby API or Nostr Wallet Connect (using [https://nwc.getalby.com/](https://nwc.getalby.com/)). Unsettled Invoices created directly using the Lndhub API will return a 404.
    /// - returns an `Invoice` object
    public func getInvoice(withHash hash: String) async throws -> Invoice {
        try await router.execute(.invoice(hash))
    }
    
    /// Decode an invoice
    /// Decode an invoice. Will also add the alias of the receiving node & route hints (LSP's).
    /// - returns a `Bolt11Invoice` objcet
    public func decodeInvoice(bolt11: String) async throws -> Bolt11Invoice {
        try await router.execute(.decodeBolt11(bolt11))
    }
}

enum InvoicesAPI {
    case createInvoice(InvoiceUploadModel)
    case incomingInvoiceHistory(InvoiceHistoryUploadModel)
    case outgoingInvoiceHistory(InvoiceHistoryUploadModel)
    case allInvoiceHistory(InvoiceHistoryUploadModel)
    case invoice(String)
    case decodeBolt11(String)
}

extension InvoicesAPI: EndpointType {
    public var baseURL: URL {
        guard let environmentURL = AlbyEnvironment.current.api else { fatalError("You must call the AlbyKit Setup method before using AlbyKit") }
        guard let url = URL(string: environmentURL.rawValue) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .createInvoice: "/invoices"
        case .incomingInvoiceHistory: "/invoices/incoming"
        case .outgoingInvoiceHistory: "/invoices/outgoing"
        case .allInvoiceHistory: "/invoices"
        case .invoice(let paymentHash): "/invoices/\(paymentHash)"
        case .decodeBolt11(let bolt11Invoice): "/decode/bolt11/\(bolt11Invoice)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .incomingInvoiceHistory, .outgoingInvoiceHistory, .allInvoiceHistory, .invoice, .decodeBolt11: .get
        case .createInvoice: .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .createInvoice(let invoice):
            return .requestParameters(encoding: .jsonEncodableEncoding(encodable: invoice))
        case .incomingInvoiceHistory(let invoiceHistory), .outgoingInvoiceHistory(let invoiceHistory), .allInvoiceHistory(let invoiceHistory):
            var parameters: Parameters = [:]
            append(invoiceHistory.before, toParameters: &parameters, withKey: "q[before]")
            append(invoiceHistory.since, toParameters: &parameters, withKey: "q[since]")
            append(invoiceHistory.createdAtLt, toParameters: &parameters, withKey: "q[created_at_lt]")
            append(invoiceHistory.createdAtGt, toParameters: &parameters, withKey: "q[created_at_gt]")
            append(invoiceHistory.page, toParameters: &parameters, withKey: "page")
            append(invoiceHistory.items, toParameters: &parameters, withKey: "items")
            
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .invoice, .decodeBolt11:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        get async {
            guard let accessToken = await AlbyEnvironment.current.delegate?.getAccessToken() else { return nil }
            return switch self {
            case .incomingInvoiceHistory, .outgoingInvoiceHistory, .allInvoiceHistory, .invoice, .decodeBolt11, .createInvoice:
                ["Authorization" : "Bearer \(accessToken)"]
            }
        }
    }
}
