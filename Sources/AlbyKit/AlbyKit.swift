import Foundation
import SwiftData

@Observable
public final class AlbyKit: Sendable {
    public init() { }
    
    static public func setup(api: API, clientID: String, clientSecret: String, redirectURI: String) async {
        await AlbyEnvironment.current.setup(api: api, clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI)
    }
    
    static public func setDelegate(_ delegate: AlbyKitDelegate) async {
        await AlbyEnvironment.current.setDelegate(delegate)
    }
}

@MainActor
public protocol AlbyKitDelegate: AnyObject, Sendable {
    func tokenUpdated(_ token: Token)
    func unautherizedUser()
    func reachabilityDegradedNetworkPerformanceDetected()
    func reachabilityNormalPerformance()
    func getAccessToken() -> String?
    func getFreshToken() -> String?
}
