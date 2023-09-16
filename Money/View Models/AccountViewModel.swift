//
//  AccountViewModel.swift
//  Money
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import Foundation
import Combine
import Network

/// Class to manage account data and connectivity status
@MainActor class AccountViewModel: ObservableObject {
    
    /// Published property for async busy state
    @Published private(set) var isBusy = false
    
    /// Published property for account balance
    @Published private(set) var accountBalance: String = "-"
    
    /// Published property for account transactions
    @Published private(set) var accountTransactions: [Tdata]? = []

    /// Published property to track network connectivity status
    @Published var isConnected = true

    /// NWPathMonitor to monitor network connectivity
    let monitor = NWPathMonitor()
    
    /// Storage for persisting account data
    private let accountStorage: AccountStorage
    
    /// Storage for persisting transaction data
    private let transactionStorage: TransactionStorage
    
    /// Network service for fetching latest data
    private let moneyService: MoneyServiceProtocol

    /// Private cancellables set
    private var cancellables = Set<AnyCancellable>()

    /// Designated initializer
    /// - Parameters:
    ///   - moneyService: Network service
    ///   - accountStorage: Storage for accounts
    ///   - transactionStorage: Storage for transactions
    init(moneyService: MoneyServiceProtocol, accountStorage: AccountStorage, transactionStorage: TransactionStorage) {
        
        // Initialize dependencies
        self.moneyService = moneyService
        self.accountStorage = accountStorage
        self.transactionStorage = transactionStorage
                
        // Check connectivity on start
        checkConnectivityAndRefresh()        
    }

    /// Check connectivity and refresh data if connected
    func checkConnectivityAndRefresh() {
        
        // Monitor connectivity
      monitor.pathUpdateHandler = { [weak self] path in
          
          // Set connected state
        if path.status == .satisfied {
          self?.isConnected = true
            
            // Refresh data asynchronously
            Task {
                print("New Connection")
              await self?.refreshAccountData()
            }
        } else {
          self?.isConnected = false
        }
      }
        
        // Start connectivity monitoring
        monitor.start(queue: .main)
    }
    
    /// Refresh account data
    func refreshAccountData() async {
      await fetchAccountData()
      await fetchAccountTransactions()
    }
    
    /// Factory method to create instance
    /// - Parameters:
    ///   - moneyService: Network service
    ///   - accountStorage: Account storage
    ///   - transactionStorage: Transaction storage
    /// - Returns: New view model instance
    static func makeAccountDataManager(moneyService: MoneyServiceProtocol, accountStorage: AccountStorage, transactionStorage: TransactionStorage) -> AccountViewModel {
        return AccountViewModel(moneyService: moneyService, accountStorage: accountStorage, transactionStorage: transactionStorage)
    }
    
    
    /// Fetch latest account data from API or cache
    func fetchAccountData() async {
        
        // Check connectivity
        if !isConnected {
            print("Not Connected")
            
            // Load from cache if offline
            if let cachedAccount = accountStorage.getAccount() {
                accountBalance = cachedAccount.balance.formatted(.currency(code: cachedAccount.currency))
            }
        }else{
            print("Connected")
            
            // Fetch from API if online
            guard let account = await moneyService.getAccount() else { return }
            
            // Save to cache
            accountStorage.saveAccount(account)
            
            // Update info for UI
            accountBalance = account.balance.formatted(.currency(code: account.currency))
            //print(accountBalance)
        }
    }
    
    /// Fetch latest transactions from API or cache
    func fetchAccountTransactions() async {
        if !isConnected {
            
            // Load from cache if offline
            if let cachedTransactions = transactionStorage.getTransactions() {
                accountTransactions = cachedTransactions.data
            }
        }else{
            
            // Fetch from API if online
            guard let transactions = await moneyService.getTransactions() else { return }
            
            // Save to cache
            transactionStorage.saveTransactions(transactions)
            // Update UI
            accountTransactions = transactions.data!
        }
    }
}
