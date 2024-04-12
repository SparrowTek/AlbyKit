
public struct KeysendPayment: AlbyCodable, Equatable, Sendable {
    public let amount: Int?
    public let description: String?
    public let descriptionHash: String?
    public let destination: String?
    public let fee: Int?
    public let customRecords: [String : String]?
    public let paymentHash: String?
    public let paymentPreimage: String?
}

public struct MultiKeysendPayment: AlbyCodable, Sendable {
    public let error: KeysendPaymentError?
    public let keysend: KeysendPayment
}

public struct KeysendPayments: AlbyCodable, Sendable {
    public let keysends: [MultiKeysendPayment]?
}

public struct KeysendPaymentError: AlbyCodable, Sendable {
    public let code: Int?
    public let error: Bool?
    public let message: String?
}
