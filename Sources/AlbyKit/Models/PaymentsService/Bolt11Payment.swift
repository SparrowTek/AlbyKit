
public struct Bolt11Payment: Codable, Equatable, Sendable {
    public let amount: Int
    public let description: String
    public let destination: String
    public let fee: Int
    public let paymentHash: String
    public let paymentPreimage: String
    public let paymentRequest: String
}
