//
//  Networking.swift
//
//
//  Created by Thomas Rademaker on 11/20/23.
//

import Foundation
import CryptoKit

extension JSONDecoder {
    static var albyDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            
            if let dateStr = try? container.decode(String.self) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                if let date = dateFormatter.date(from: dateStr) {
                    return date
                }
                
            } else if let dateInt = try? container.decode(Int.self) {
                return Date(timeIntervalSince1970: TimeInterval(dateInt))
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
        }
        
        return decoder
    }
}

class AlbyRouterDelegate: NetworkRouterDelegate {
    func intercept(_ request: inout URLRequest) async {
        // NO-OP
    }
    
    func shouldRetry(error: Error, attempts: Int) async throws -> Bool {
        if case .statusCode(let code, _) = error as? NetworkError, code == .unauthorized {
            if attempts == 1 {
                do {
                    try await OAuthService().refreshAccessToken()
                    return true
                } catch {
                    AlbyEnvironment.current.delegate?.unautherizedUser()
                    return false
                }
            } else {
                AlbyEnvironment.current.delegate?.unautherizedUser()
                return false
            }
        } else {
            return false
        }
    }
}
