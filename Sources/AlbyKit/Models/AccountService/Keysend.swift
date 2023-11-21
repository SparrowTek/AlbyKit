
public struct Keysend: Codable, Sendable {
    public let keysendPubkey: String
    public let keysendCustomKey: String
    public let keysendCustomValue: String
    public let lightningAddress: String?
}
