//Created for Money in 2023
// Using Swift 5.0

import Foundation

/// Transaction model for API response
struct Transaction: Codable {
    /// Total number of transactions
    var total: Int
    
    /// Number of transactions in current response
    var count: Int
    
    /// Flag if this is the last page
    var last: Bool
    
    /// Array of transaction data
    var data: [Tdata]?

    enum CodingKeys: String, CodingKey {
        case total = "total"
        case count = "count"
        case last = "last"
        case data = "data"
    }
}

/// Model for a single transaction
struct Tdata: Codable,Identifiable{
    
    /// Title or description of transaction
    let title: String?
    
    /// Transaction amount
    let amount: Double?
    
    /// Currency of transaction
    let currency: String?
    
    /// Unique ID
    let id: String?
}
