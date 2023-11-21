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
        
        return decoder
    }
}

let testAPI = "api.regtest.getalby.com"
let prodAPI = "api.getalby.com"
let routerDelegate = AlbyRouterDelegate()

class AlbyRouterDelegate: NetworkRouterDelegate {
    func intercept(_ request: inout URLRequest) async {
        // TODO: add any headers here
//        let errorMessage = """
//PODCASTINDEXKIT Error: your apiKey, secretKey, and userAgent were not set.
//Please follow the intructions in the README for setting up the PodcastIndexKit framework
//Hint: You must call the static setup(apiKey: String, apiSecret: String, userAgent: String) method before using the framework
//"""
//        guard let apiKey = PodcastIndexKit.apiKey, let apiSecret = PodcastIndexKit.apiSecret, let userAgent = PodcastIndexKit.userAgent else { fatalError(errorMessage) }
//        
//        // prep for crypto
//        let apiHeaderTime = String(Int(Date().timeIntervalSince1970))
//        let data4Hash = apiKey + apiSecret + "\(apiHeaderTime)"
//        
//        // ======== Hash them to get the Authorization token ========
//        let inputData = Data(data4Hash.utf8)
//        let hashed = Insecure.SHA1.hash(data: inputData)
//        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
//        
//        // set Headers
//        request.addValue(apiHeaderTime, forHTTPHeaderField: "X-Auth-Date")
//        request.addValue(apiKey, forHTTPHeaderField: "X-Auth-Key")
//        request.addValue(hashString, forHTTPHeaderField: "Authorization")
//        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // Doesn't need to be set here/ netweorking code sets this elsewhere
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
