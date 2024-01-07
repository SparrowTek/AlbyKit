
import Foundation

/// OAuth Token Information
public struct Token: Codable, Sendable {
    public let accessToken: String
    public let expiresIn: Int
    public let refreshToken: String
    public let scope: String
    public let tokenType: String
}

internal struct TokenMetadata: Codable, Sendable {
    let expiresIn: Int
    let scope: String
    let tokenType: String
    let createdAt: Date
}
