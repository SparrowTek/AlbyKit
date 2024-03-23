import Foundation
import SwiftData

@Observable
@AlbyActor
public final class AlbyKit: Sendable {
    public init() { }
    
    static public func setup(api: API, clientID: String, clientSecret: String, redirectURI: String) {
        AlbyEnvironment.current.setup(api: api, clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI)
    }
    
    static public func setDelegate(_ delegate: AlbyKitDelegate) {
        AlbyEnvironment.current.setDelegate(delegate)
    }
    
    public let accountService = AccountsService()
    public let invoicesService = InvoicesService()
    public let paymentsService = PaymentsService()
    public let oauthService = OAuthService()
    public let helpers = Helpers()
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
