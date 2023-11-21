import Foundation

public struct AccountSummary: Codable, Sendable {
    public let balance: Int
    public let boostagramsCount: Int
    public let currency: Currency
    public let invoicesCount: Int
    public let lastInvoiceAt: Date // "2022-06-02T08:40:08.000Z", // TODO: properly support Date format with Codable
    public let transactionsCount: Int
    public let unit: Unit
}
