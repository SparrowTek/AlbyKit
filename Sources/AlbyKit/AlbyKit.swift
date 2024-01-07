import Foundation
import SwiftData

@Observable
public final class AlbyKit {
    public init() { }
    
    static public func setup(api: API, clientID: String, clientSecret: String, redirectURI: String) {
        AlbyEnvironment.current.setup(api: api, clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI)
    }
    
    static public func set(accessToken: String?, refreshToken: String?) {
        AlbyEnvironment.current.accessToken = accessToken
        AlbyEnvironment.current.refreshToken = refreshToken
    }
    
    static public func setDelegate(_ delegate: AlbyKitDelegate) {
        AlbyEnvironment.current.delegate = delegate
    }
    
    public let accountService = AccountsService()
    public let invoicesService = InvoicesService()
    public let paymentsService = PaymentsService()
    public let oauthService = OAuthService()
}

public protocol AlbyKitDelegate: AnyObject {
    func tokenUpdated(_ token: Token)
    func unautherizedUser()
    func reachabilityDegradedNetworkPerformanceDetected()
    func reachabilityNormalPerformance()
}
