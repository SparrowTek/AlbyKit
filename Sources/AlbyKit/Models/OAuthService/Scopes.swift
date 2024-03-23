
/// Scopes
/// Scopes allow you to request fine-grained access permissions for your application.
public enum Scopes: String, AlbyCodable, Sendable {
    /// Request the user's Lightning Address and their keysend information.
    case accountRead = "account:read"
    
    /// Create invoices on a user's behalf.
    case invoicesCreate = "invoices:create"
    
    /// Read a user's incoming transaction history.
    case invoicesRead = "invoices:read"
    
    /// Read a user's outgoing transaction history.
    case transactionsRead = "transactions:read"
    
    /// Read a user's balance.
    case balanceRead = "balance:read"
    
    /// Send payments on behalf of a user.
    case paymentsSend = "payments:send"
}
