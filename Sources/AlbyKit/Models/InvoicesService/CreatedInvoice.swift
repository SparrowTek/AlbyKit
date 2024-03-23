import Foundation

public struct CreatedInvoice: AlbyCodable, Hashable, Sendable {
    public let amount: Int
    public let expiresAt: Date
    public let paymentHash: String
    public let paymentRequest: String
    
    public init(amount: Int, expiresAt: Date, paymentHash: String, paymentRequest: String) {
        self.amount = amount
        self.expiresAt = expiresAt
        self.paymentHash = paymentHash
        self.paymentRequest = paymentRequest
    }
}
