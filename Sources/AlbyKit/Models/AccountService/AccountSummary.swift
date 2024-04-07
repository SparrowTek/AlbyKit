import Foundation

public struct AccountSummary: AlbyCodable, Sendable {
    public let balance: Int?
    public let boostagramsCount: Int?
    public let currency: String?
    public let invoicesCount: Int?
    public let lastInvoiceAt: Date?
    public let transactionsCount: Int?
    public let unit: Unit?
}
