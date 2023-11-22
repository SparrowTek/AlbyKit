
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

/*
 400: Bad Request
 {
   "code": 8,
   "error": true,
   "message": "string"
 }
 500: Internal Server Error
 {
     "code": 10,
     "error": true,
     "message": "error"
 }
 
 400: Bad Request
 Invalid request body or Invoice could not be created
 {
   "code": 0,
   "error": true,
   "message": "string"
 }
 */
