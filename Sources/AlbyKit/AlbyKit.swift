import Foundation
import SwiftData

@Observable
public final class AlbyKit {
    public init() { }
    
    static public func setup(api: API, clientID: String, clientSecret: String, redirectURI: String) {
        AlbyEnvironment.current.setup(api: api, clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI)
    }
    
    public let accountService = AccountsService()
    public let invoicesService = InvoicesService()
    public let paymentsService = PaymentsService()
}

