
public enum AlbyError: Error, Sendable {
    case message(ErrorMessage)
    case network(NetworkError)
}

public struct ErrorMessage: Codable, Sendable {
    public let code: Int
    public let error: Bool
    public let message: String
    
    public init(code: Int, error: Bool, message: String) {
        self.code = code
        self.error = error
        self.message = message
    }
}

public enum AlbyErrorCode: Int, Codable, Sendable {
    case generic
}
