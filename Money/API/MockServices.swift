//Created for Money in 2023
// Using Swift 5.0

import Foundation
import Combine


class MockMoneyService: MoneyServiceProtocol {
    
    private let _isBusy = PassthroughSubject<Bool, Never>()
    lazy private(set) var isBusy = _isBusy.eraseToAnyPublisher()
    
    func getTransactions() async -> Transaction? {
        
        let fakeData : [Tdata] = [Tdata(title: "Shell Gasoline", amount: 12.3, currency: "USD", id: "4995a89c-af30-41c0-9754-a3bb4a34fe66")]
        return Transaction(total: 11, count: 1, last: false,data: fakeData)
    }
    

  func getAccount() async -> Account? {
    return Account(balance: 100, currency: "USD")
  }
}

class MockStorage: AccountStorage {

  func getAccount() -> Account? {
    return nil
  }

  func saveAccount(_ account: Account) {
    // nothing
  }

}

class MockTrStorage: TransactionStorage {
    func getTransactions() -> Transaction? {
        return nil
    }
    
    func saveTransactions(_ transactions: Transaction) {
        //nothing
    }
}
