
public struct LightningAddressDetails: AlbyCodable, Sendable {
    public let lnurlp: LNURLLp?
    public let keysend: KeysendDetails?
    public let nostr: NostrDetails?
}

public struct LNURLLp: AlbyCodable, Sendable {
    public let allowsNostr: Bool?
    public let callback: String?
    public let commentAllowed: Int?
    public let maxSendable: Int?
    public let metadata: String?
    public let minSendable: Int?
    public let nostrPubkey: String?
    public let payerData: PlayerData?
    public let status: String?
    public let tag: String?
}

public struct PlayerData: AlbyCodable, Sendable {
    public let email: PlayerDataValue?
    public let name: PlayerDataValue?
    public let pubkey: PlayerDataValue?
}

public struct PlayerDataValue: AlbyCodable, Sendable {
    public let mandatory: Bool?
}

public struct KeysendDetails: AlbyCodable, Sendable {
    public let customData: [KeysendCustomData]?
    public let pubkey: String?
    public let status: String?
    public let tag: String?
}

public struct KeysendCustomData: AlbyCodable, Sendable {
    public let customKey: String?
    public let customValue: String?
}

public struct NostrDetails: AlbyCodable, Sendable {
    public let names: NostrNames?
}

public struct NostrNames: AlbyCodable, Sendable {
    public let hello: String?
}
