//
//  AccountViewModelTests.swift
//  MoneyTests
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import XCTest
@testable import Money

final class AccountViewModelTests: XCTestCase {

    @MainActor func testFetchAccountData() async {
        // Use mock service
        let moneyService = MockMoneyService()
        let storage = MockStorage()
        let trStorage = MockTrStorage()
        
        let viewModel = AccountViewModel(moneyService: moneyService, accountStorage: storage, transactionStorage: trStorage)

        XCTAssertEqual(viewModel.accountBalance, "-")
        XCTAssertFalse(viewModel.isBusy)

        await viewModel.fetchAccountData()

        XCTAssertEqual(viewModel.accountBalance, "$100.00")
        XCTAssertFalse(viewModel.isBusy)
    }
}
