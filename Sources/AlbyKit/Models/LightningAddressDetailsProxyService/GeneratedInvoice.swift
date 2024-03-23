
public struct GeneratedInvoice: AlbyCodable, Sendable {
    public let body: GeneratedInvoiceBody
}

public struct GeneratedInvoiceBody: AlbyCodable, Sendable {
    public let pr: String
    public let routes: [String]
    public let status: String
    public let successAction: SuccessAction
    public let verify: String
}

public struct SuccessAction: AlbyCodable, Sendable {
    public let message: String
    public let tag: String
}
