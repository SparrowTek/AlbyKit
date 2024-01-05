import Foundation

public struct PaymentsService {
    private let router = NetworkRouter<PaymentsAPI>(decoder: .albyDecoder)
    
    /// BOLT11 payment
    /// Scope needed: payments:send
    /// Pay a lightning invoice (bolt11)
    /// - returns a `Bolt11Payment` object
    public func bolt11Payment(uploadModel: Bolt11PaymentUploadModel) async throws -> Bolt11Payment {
        try await router.execute(.bolt11(uploadModel))
    }
    
    /// Keysend payment
    /// Scope needed: payments:send
    /// Send a "spontaneous" payment (keysend). Used for push realtime/streaming push payments
    /// - returns a `KeysendPayment` object
    public func keysendPayment(uploadModel: KeysendPaymentUploadModel) async throws -> KeysendPayment {
        try await router.execute(.keysend(uploadModel))
    }
    
    /// Multi keysend payment
    /// Scope needed: `payments:send`
    /// Send multiple spontaneous keysend payments. Useful for doing value4value splits. Request and response are an array of the single keysend payment request and response.
    /// - returns a `KeysendPayments` object which is an array of `KeysendPayment` objects
    public func multiKeysendPayment(uploadModel: MultiKeysendPaymentUploadModel) async throws -> KeysendPayments {
        try await router.execute(.multiKeysend(uploadModel))
    }
}

enum PaymentsAPI {
    case bolt11(Bolt11PaymentUploadModel)
    case keysend(KeysendPaymentUploadModel)
    case multiKeysend(MultiKeysendPaymentUploadModel)
}

extension PaymentsAPI: EndpointType {
    public var baseURL: URL {
        guard let environmentURL = AlbyEnvironment.current.api else { fatalError("You must call the AlbyKit Setup method before using AlbyKit") }
        guard let url = URL(string: environmentURL.rawValue) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .bolt11: "/payments/bolt11"
        case .keysend: "/payments/keysend"
        case .multiKeysend: "/payments/keysend/multi"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .bolt11, .keysend, .multiKeysend: .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .bolt11(let uploadModel): return .requestParameters(encoding: .jsonEncodableEncoding(encodable: uploadModel))
        case .keysend(let uploadModel): return .requestParameters(encoding: .jsonEncodableEncoding(encodable: uploadModel))
        case .multiKeysend(let uploadModel): return .requestParameters(encoding: .jsonEncodableEncoding(encodable: uploadModel))
        }
    }
    
    var headers: HTTPHeaders? {
        guard let accessToken = AlbyEnvironment.current.accessToken else { return nil }
        return switch self {
        case .bolt11, .keysend, .multiKeysend:
            ["Authorization" : "Bearer \(accessToken)"]
        }
    }
}



