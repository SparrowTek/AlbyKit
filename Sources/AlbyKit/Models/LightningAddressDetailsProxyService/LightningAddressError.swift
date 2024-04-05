
// TODO: return this if lightning address details fail
public struct LightningAddressError: Codable, Sendable {
    public let invoice: InvoiceError
}

public struct InvoiceError: Codable, Sendable {
    public let reason: String
    public let status: String
}
