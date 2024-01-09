
public struct AccountBalance: Codable, Sendable {
    public let balance: Int
    public let currency: String
    public let unit: Unit
}
