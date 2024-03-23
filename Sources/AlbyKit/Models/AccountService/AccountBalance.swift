
public struct AccountBalance: AlbyCodable, Sendable {
    public let balance: Int
    public let currency: String
    public let unit: Unit
}
