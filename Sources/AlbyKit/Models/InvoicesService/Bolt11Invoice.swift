import Foundation
import BreezSDKLiquid

public struct Bolt11Invoice: AlbyCodable, Sendable {
    public let currency: String?
    public let createdAt: Date?
    public let expiry: Int?
    public let payee: String?
    public let msatoshi: Int?
    public let description: String?
    public let paymentHash: String?
    public let minFinalCltvExpiry: Int?
    public let amount: Int?
    public let payeeAlias: String?
    public let routeHintAliases: [String]? // TODO: is string array the correct type?
}

public struct ParsedBolt11Invoice {
    var amount: UInt64?
    
    init?(invoice: String) {
        amount = getSatsFromInvoice(bolt11: invoice)
    }
    
    private func getSatsFromInvoice(bolt11: String) -> UInt64? {
        do {
            // Parse the Bolt 11 invoice using Breez SDK
            let parsedInvoice = try BreezSDKLiquid.parseInvoice(input: bolt11)
            
            // Extract the amount in satoshis
            if let amountMsat = parsedInvoice.amountMsat {
                let sats = amountMsat / 1000
                return sats
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
