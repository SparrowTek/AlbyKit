
public struct PersonalInformation: AlbyCodable, Sendable {
    public let identifier: String?
    public let email: String?
    public let name: String?
    public let avatar: String?
    public let keysendCustomKey: String?
    public let keysendCustomValue: String?
    public let keysendPubkey: String?
    public let lightningAddress: String?
    public let nostrPubkey: String?
}
