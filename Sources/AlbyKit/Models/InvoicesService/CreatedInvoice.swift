import Foundation

public struct CreatedInvoice: Codable, Sendable {
    public let expires_at: Date // "2022-06-02T08:31:15Z", // TODO: add proper codable date support
    public let paymentHash: String
    public let paymentRequest: String
}
