
/// Object needed to pay a bolt11 invoice.
public struct Bolt11PaymentUploadModel: AlbyCodable, Sendable {
    
    /// invoice to be paid
    public var invoice: String
    
    public init(invoice: String) {
        self.invoice = invoice
    }
}
