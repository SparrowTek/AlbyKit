import Foundation
import SwiftData

@Observable
public final class AlbyKit {
    public init() { }
    
//    static public func setup(apiKey: String, apiSecret: String, userAgent: String) {
//        self.apiKey = apiKey
//        self.apiSecret = apiSecret
//        self.userAgent = userAgent
//    }
//    
//    static var apiKey: String?
//    static var apiSecret: String?
//    static var userAgent: String?
    
    public let accountService = AccountsService()
    public let invoicesService = InvoicesService()
    public let paymentsService = PaymentsService()
}

