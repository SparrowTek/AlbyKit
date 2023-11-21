
public struct AccountBalance: Codable, Sendable {
    public let balance: Int
    public let currency: Currency
    public let unit: Unit
}
