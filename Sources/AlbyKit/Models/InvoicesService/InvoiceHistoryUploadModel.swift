
public struct InvoiceHistoryUploadModel: Codable, Sendable {
    
    /// Filter invoices created before the given invoice identifier
    public var before: String?
    
    /// Filter invoices created after the given invoice identifier
    public var since: String?
    
    /// Filter invoices created before this Unix Timestamp in UTC (e.g. 1681992321)
    public var createdAtLt: Int?
    
    /// Filter invoices created after this Unix Timestamp in UTC (e.g. 1681992321)
    public var createdAtGt: Int?
    
    /// Page number (1 is the first page)
    public var page: Int?
    
    /// Items per page (Default 25)
    public var items: Int?
    
    public init(before: String? = nil, since: String? = nil, createdAtLt: Int? = nil, createdAtGt: Int? = nil, page: Int? = nil, items: Int? = nil) {
        self.before = before
        self.since = since
        self.createdAtLt = createdAtLt
        self.createdAtGt = createdAtGt
        self.page = page
        self.items = items
    }
}
