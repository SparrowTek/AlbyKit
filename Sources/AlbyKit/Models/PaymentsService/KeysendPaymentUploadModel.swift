
/// Keysend payment
/// Make a spontaneous keysend payment, with optional custom records. See for example: [https://github.com/lightning/blips/blob/master/blip-0010.md](https://github.com/lightning/blips/blob/master/blip-0010.md)
public struct KeysendPaymentUploadModel: Codable, Sendable {
    
    /// Amount in satoshi. Must be a whole number greater than 0. (millisats are not supported)
    public var amount: Int64
    
    /// Destination hex-string pubkey (a string starting with 02 or 03)
    public var destination: String
    
    /// Internal memo
    public var memo: String?
    
    /// map with custom records. See [https://www.webln.guide/building-lightning-apps/webln-reference/webln.keysend](https://www.webln.guide/building-lightning-apps/webln-reference/webln.keysend)
    public var customRecords: [String : String]?
    
    public init(amount: Int64, destination: String, memo: String? = nil, customRecords: [String : String]? = nil) {
        self.amount = amount
        self.destination = destination
        self.memo = memo
        self.customRecords = customRecords
    }
}

public struct MultiKeysendPaymentUploadModel: Codable, Sendable {
    
    /// Array of keysend objects (`KeysendPaymentUploadModel`)
    public var keysends: [KeysendPaymentUploadModel]
    
    public init(keysends: [KeysendPaymentUploadModel]) {
        self.keysends = keysends
    }
}
