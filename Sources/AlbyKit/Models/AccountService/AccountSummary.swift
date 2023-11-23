import Foundation

public struct AccountSummary: Codable, Sendable {
    public let balance: Int
    public let boostagramsCount: Int
    public let currency: Currency
    public let invoicesCount: Int
    public let lastInvoiceAt: Date
    public let transactionsCount: Int
    public let unit: Unit
}
