import Foundation

public struct CreatedInvoice: Codable, Hashable, Sendable {
    public let amount: Int
    public let expiresAt: Date
    public let paymentHash: String
    public let paymentRequest: String
}
