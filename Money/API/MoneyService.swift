//
//  MoneyService.swift
//  Money
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import Foundation
import Combine

/// Protocol for money service API
protocol MoneyServiceProtocol {
    
    /// Publisher for busy state
    var isBusy: AnyPublisher<Bool, Never> { get }
    
    /// Get account data
    /// - Returns: Account model or nil if error
    func getAccount() async -> Account?
    
    /// Get transactions
    /// - Returns: Transactions model or nil if error
    func getTransactions() async -> Transaction?
}

/// Network service implementation
class MoneyService: MoneyServiceProtocol {
    
    /// Subject to publish busy state
    private let _isBusy = PassthroughSubject<Bool, Never>()
    
    /// Published busy state
    lazy private(set) var isBusy = _isBusy.eraseToAnyPublisher()

    /// Base URL for API
    private static let serviceBaseURL = URL(string: "https://8kq890lk50.execute-api.us-east-1.amazonaws.com/prd/accounts/0172bd23-c0da-47d0-a4e0-53a3ad40828f")!
    private let session = URLSession.shared

    /// Get account data from API
    /// - Returns: Account model or nil if error
    func getAccount() async -> Account? {
        await getData("balance")
    }

    /// Get transactions from API
    /// - Returns: Transactions model or nil if error
    func getTransactions() async -> Transaction? {
        await getData("transactions")
    }

    
//    func getAdvice() async -> Advice? {
//
//    }
    
    /// Generic method to get data from API
    /// - Parameter endpoint: API endpoint
    /// - Returns: Generic decoded model or nil if error
    private func getData<T: Codable>(_ endpoint: String) async -> T? {
        
        // Update busy state
        _isBusy.send(true)
        
        // Reset busy state when done
        defer { _isBusy.send(false) }

        // Construct URL with endpoint
        var dataURL = Self.serviceBaseURL.appending(component: endpoint)
        
        // Add query items as needed
        if endpoint == "transactions" {
            // Adding limit of getting 10 elements
            dataURL.append(queryItems: [URLQueryItem(name: "limit", value:"10")])
        }
        
        // Fetch data
        do {
            let (data, _) = try await session.data(from: dataURL)
            
            // Decode model
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            // Handle errors
            print("Error getting data from \(endpoint): \(error)")
        }

        return nil
    }
}
