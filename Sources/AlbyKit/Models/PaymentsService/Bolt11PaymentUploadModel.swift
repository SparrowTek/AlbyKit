
/// Object needed to pay a bolt11 invoice.
public struct Bolt11PaymentUploadModel: AlbyCodable, Sendable {
    
    /// invoice to be paid
    public var invoice: String
    
    /// invoice amount (required if none in invoice itself). Must be a whole number greater than 0 (millisats not supported)
    public var amount: Int64
    
    public init(invoice: String, amount: Int64) {
        self.invoice = invoice
        self.amount = amount
    }
}
