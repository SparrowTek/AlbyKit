import Foundation

public struct Bolt11Invoice: AlbyCodable, Sendable {
    public let currency: String
    public let createdAt: Date
    public let expiry: Int
    public let payee: String
    public let msatoshi: Int
    public let description: String
    public let paymentHash: String
    public let minFinalCltvExpiry: Int
    public let amount: Int
    public let payeeAlias: String
    public let routeHintAliases: [String] // TODO: is string array the correct type?
}
