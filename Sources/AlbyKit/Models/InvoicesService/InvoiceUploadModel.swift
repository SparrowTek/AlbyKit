
/// Invoice to be created
public struct InvoiceUploadModel: Codable, Sendable {
    /// amount, must be a whole number in sats (millisats are not supported).
    public var amount: Int64
    
    /// Arbitrary text (included in the BOLT11 invoice)
    public var description: String?
    
    /// Pass a hash of the description instead of the description (for private or long descriptions)
    public var descriptionHash: String?
    
    /// currency of the invoice. Default is "btc"
    public var currency: String?
    
    /// same as `description` field.
    public var memo: String?
    
    /// Arbitrary text to save alongside the invoice (not included in the BOLT11 invoice)
    public var comment: String?
    
    /// Arbitrary data to save alongside the invoice (not included in the BOLT11 invoice)
//    public var metadata: [String : Any]? // TODO: figure out metadata's type
    
    /// Name of payer (not included in the BOLT11 invoice)
    public var payerName: String?
    
    /// Email of payer (not included in the BOLT11 invoice)
    public var payerEmail: String?
    
    /// Nostr or node pubkey of payer to store with the invoice (not included in the BOLT11 invoice)
    public var payerPubkey: String?
    
    public init(amount: Int64, description: String? = nil, descriptionHash: String? = nil, currency: String? = nil, memo: String? = nil, comment: String? = nil, payerName: String? = nil, payerEmail: String? = nil, payerPubkey: String? = nil) {
        self.amount = amount
        self.description = description
        self.descriptionHash = descriptionHash
        self.currency = currency
        self.memo = memo
        self.comment = comment
        self.payerName = payerName
        self.payerEmail = payerEmail
        self.payerPubkey = payerPubkey
    }
}
