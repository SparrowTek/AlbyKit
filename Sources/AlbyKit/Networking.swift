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

let testAPI = "api.regtest.getalby.com"
let prodAPI = "api.getalby.com"
let routerDelegate = AlbyRouterDelegate()

class AlbyRouterDelegate: NetworkRouterDelegate {
    func intercept(_ request: inout URLRequest) async {
        // TODO: add any headers here
    }
    
    func shouldRetry(error: Error, attempts: Int) async throws -> Bool {
//        false // TODO: implement shouldRetry
        
        
        func getNewToken() async throws -> Bool {
//            shouldRefreshToken = true
//            let newSession = try await AtProtoLexicons().refresh(attempts: attempts + 1)
//            accessToken = newSession.accessJwt
//            refreshToken = newSession.refreshJwt
//            await delegate?.sessionUpdated(newSession)
            
            return true
        }
        
        // TODO: verify this works!
        if case .network(let networkError) = error as? AlbyError, case .statusCode(let statusCode, _) = networkError, let statusCode = statusCode?.rawValue, (400..<500).contains(statusCode), attempts == 1 {
            return try await getNewToken()
        } else if case .message(let message) = error as? AlbyError, message.code == AlbyErrorCode.generic.rawValue {
            return try await getNewToken()
        }
        
        return false
    }
}
