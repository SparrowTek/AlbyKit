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
        if case .network(let networkError) = error as? AlbyError, case .statusCode(let code, _) = networkError, code == .unauthorized {
            AlbyEnvironment.current.delegate?.reachabilityNormalPerformance()
            if attempts == 1 {
                await AlbyEnvironment.current.tokenRefreshRequired = true
                return true
            } else {
                AlbyEnvironment.current.delegate?.unautherizedUser()
                return false
            }
        } else if case .tokenRefresh = error as? NetworkError {
            AlbyEnvironment.current.delegate?.unautherizedUser()
            return false
        } else {
            if error.isOtherConnectionError {
                AlbyEnvironment.current.delegate?.reachabilityDegradedNetworkPerformanceDetected()
            } else {
                AlbyEnvironment.current.delegate?.reachabilityNormalPerformance()
            }
            
            return false
        }
    }
}

fileprivate var NSURLErrorConnectionFailureCodes: [Int] {
    [
        NSURLErrorBackgroundSessionInUseByAnotherProcess, /// Error Code: `-996`
        NSURLErrorCannotFindHost, /// Error Code: ` -1003`
        NSURLErrorCannotConnectToHost, /// Error Code: ` -1004`
        NSURLErrorNetworkConnectionLost, /// Error Code: ` -1005`
        NSURLErrorNotConnectedToInternet, /// Error Code: ` -1009`
        NSURLErrorSecureConnectionFailed /// Error Code: ` -1200`
    ]
}

extension Error {
    /// Indicates an error which is caused by various connection related issue or an unaccepted status code.
    /// See: `NSURLErrorConnectionFailureCodes`
    fileprivate var isOtherConnectionError: Bool {
        NSURLErrorConnectionFailureCodes.contains(_code)
    }
}
