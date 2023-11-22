import Foundation

// TODO: which properties are optional
public struct Invoice: Codable, Sendable {
    public let amount: Int
    public let boostagram: Boostagram?
    public let comment: String?
    public let createdAt: Date // "2022-07-05T17:02:20.343Z", TODO: date set properly in codable
    public let creationDate: Int // 1657040540, TODO: this is a date but isn't the same format, can we make this work with Codabale
    public let currency: Currency
    public let customRecords: [String : String]?
    public let descriptionHash: String?
    public let expiresAt: Date // "2022-07-05T17:17:20.000Z", TODO: more date stuff
    public let expiry: Int
    public let identifier: String
    public let keysendMessage: String?
    public let memo: String?
    public let payerName: String?
    public let payerEmail: String?
    public let payerPubkey: String?
    public let preimage: String
    public let paymentHash: String
    public let paymentRequest: String
    public let rHashStr: String
    public let settled: Bool?
    public let settledAt: Date? // TODO: more date stuff "2022-07-05T17:02:20.000Z",
    public let state: InvoiceState
    public let type: String
    public let value: Int
    
    // MARK: unsettled invoice properties
    public let fiatCurrency: Currency?
    public let fiatInCents: Int?
    public let metadata: String? // TODO: is this the correct type?
    public let destinationAlias: String? // TODO: is this the correct type?
    public let destinationPubkey: String? // TODO: is this the correct type?
    public let firstRouteHintPubkey: String? // TODO: is this the correct type?
    public let firstRouteHintAlias: String? // TODO: is this the correct type?
    public let qrCodePng: String?
    public let qrCodeSvg: String?
}

public enum InvoiceState: String, Codable, Sendable {
    case created = "CREATED"
    case settled = "SETTLED"
}

public struct Boostagram: Codable, Sendable {
    public let action: String
    public let appName: String
    public let boostLink: String
    public let episode: String
    public let feedID: Int
    public let itemID: Int
    public let message: String?
    public let name: String
    public let podcast: String
    public let senderId: String
    public let senderName: String
    public let time: String
    public let ts: Int
    public let url: String
    public let valueMsatTotal: Int
}
