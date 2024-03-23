import Foundation

protocol AlbyCodable: AlbyEncodable, AlbyDecodable, Sendable {}
protocol AlbyEncodable: Encodable, Sendable {}
protocol AlbyDecodable: Decodable, Sendable {}
