import Foundation

public struct CreatedInvoice: Codable, Sendable {
    public let expires_at: Date
    public let paymentHash: String
    public let paymentRequest: String
}
