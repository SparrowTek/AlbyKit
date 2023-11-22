public struct Bolt11Invoice: Codable, Sendable {
    public let currency: Currency
    public let createdAt: Int // 1693210330,  // TODO: should this be a date?
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
