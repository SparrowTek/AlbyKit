
public struct Bolt11Payment: AlbyCodable, Equatable, Sendable {
    public let amount: Int
    public let descriptionHash: String
    public let destination: String
    public let fee: Int
    public let paymentHash: String
    public let paymentPreimage: String
    public let paymentRequest: String
}
