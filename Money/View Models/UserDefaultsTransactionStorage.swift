//Created for Money in 2023
// Using Swift 5.0

import Foundation
import Combine

/// Protocol for account data storage
protocol AccountStorage {
    /// Get saved account
    /// - Returns: Account if found, nil otherwise
    func getAccount() -> Account?
    
    /// Save account
    /// - Parameter account: Account to save
    func saveAccount(_ account: Account)
}

/// Protocol for transaction data storage
protocol TransactionStorage {
    
    /// Get saved transactions
    /// - Returns: Transactions if found, nil otherwise
    func getTransactions() -> Transaction?
    
    /// Save transactions
    /// - Parameter transactions: Transactions to save
    func saveTransactions(_ transactions: Transaction)
}

/// Store account in UserDefaults
class UserDefaultsAccountStorage: AccountStorage {

    /// UserDefaults for storage
    private let userDefaults = UserDefaults.standard
    
    /// Get saved account
    /// - Returns: Decoded account if found, nil otherwise
    func getAccount() -> Account? {
        guard let data = userDefaults.data(forKey: "account") else { return nil }
        return try? JSONDecoder().decode(Account.self, from: data)
    }
    
    /// Save encoded account to UserDefaults
    /// - Parameter account: Account to save
    func saveAccount(_ account: Account) {
        if let data = try? JSONEncoder().encode(account) {
            userDefaults.set(data, forKey: "account")
        }
    }
}

/// Store transactions in UserDefaults
class UserDefaultsTransactionStorage: TransactionStorage {
    
    /// UserDefaults for storage
    private let userDefaults = UserDefaults.standard
    
    /// Get saved transactions
    /// - Returns: Decoded transactions if found, nil otherwise
    func getTransactions() -> Transaction? {
        guard let data = userDefaults.data(forKey: "transactions") else { return nil }
        return try? JSONDecoder().decode(Transaction.self, from: data)
    }
    
    /// Save encoded transactions to UserDefaults
    /// - Parameter transactions: Transactions to save
    func saveTransactions(_ transactions: Transaction) {
        if let data = try? JSONEncoder().encode(transactions) {
            userDefaults.set(data, forKey: "transactions")
        }
    }
}
