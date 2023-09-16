//
//  AccountView.swift
//  Money
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import SwiftUI

/// Primary account screen view
struct AccountView: View {
    
    /// Environment object for launch screen handling
    @EnvironmentObject private var launchScreenStateManager: LaunchScreenStateManager
    
    /// StateObject view model
    @StateObject private var viewModel : AccountViewModel
    
    /// Initialize and create view model
    init() {
        
        // Create dependencies
        let moneyService = MoneyService()
        let accountStorage = UserDefaultsAccountStorage()
        let transactionStorage = UserDefaultsTransactionStorage()

        // Create view model
        _viewModel = StateObject(wrappedValue: AccountViewModel.makeAccountDataManager(moneyService: moneyService, accountStorage: accountStorage, transactionStorage: transactionStorage))
    }

    /// Flag to show alert popup
    @State private var showAlert = false
    
    /// Flag to track "purchased" state
    @State private var hasPurchased = false
    
    /// Compose UI
    var body: some View {
        VStack(alignment: .leading) {
            
            // Account balance
            Text("Account Balance")
                .font(.subheadline)
                .bold()

            HStack {
                
                // Show progress indicator
                if viewModel.isBusy {
                    ProgressView()
                } else {
                    
                    // Otherwise show balance
                    Text(viewModel.accountBalance)
                        .font(.largeTitle)
                        .bold()
                }
            }
            .animation(.default, value: viewModel.isBusy)

            Spacer()
            
            // Transactions list
            List(viewModel.accountTransactions!.sorted(by: {
                $0.amount ?? 0  < $1.amount ?? 1
            })) { transaction in
                HStack {
                    Text(transaction.title!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        
                    Text(String(transaction.amount!))
                        .padding(.trailing,-15)
                }.frame(height: 25)
            }
            .environment(\.defaultMinListRowHeight, 25)
            .padding(.leading,-38)
            .scrollContentBackground(.hidden)
            
            // Purchase button
            Button(action: {
                showAlert = true
            }) {
                ZStack {
                    
                    // Button content
                    if !hasPurchased{
                        Rectangle()
                            .foregroundColor(Color(red: 0.918, green: 0.949, blue: 1, opacity: 1))
                            .cornerRadius(16)
                            .frame(height: 100)
                    }else{
                        Rectangle()
                            .foregroundColor(Color(red: 0.905, green: 0.956, blue: 0.909, opacity: 1))
                            .cornerRadius(16)
                            .frame(height: 110)
                    }

                    HStack {
                        if hasPurchased {
                            Image("purchased", bundle: .main).resizable().frame(width: 28, height: 28, alignment: .leading).padding(10)
                                .foregroundColor(.white)
                        } else {
                            Image("notpurchased", bundle: .main).resizable().frame(width: 28, height: 28, alignment: .leading).padding(10)
                                .foregroundColor(.white)
                        }

                        Spacer()
                        VStack(alignment: .leading,spacing: 2){
                            if !hasPurchased {
                                Text("Go Pro!")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                    .padding([.bottom],1)
                                    .minimumScaleFactor(0.9)
                                Text("Get insights on how to save money\nusing premium advice")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.9)
                                    
                            }else{
                                Text("Cancel Unused Subscriptions")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                    .padding([.bottom],1)
                                    .padding([.trailing],35)
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                                Text("Small numbers add up to big\nnumbers! Review recurring charges\nand drop those you no longer use.")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(3)
                                    .minimumScaleFactor(0.9)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                }
            }
            .padding(.leading,-20)
            .padding(.bottom, 37)
            .padding(.horizontal, 40)

        }
        // Layout
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading], 28)
        .padding([.trailing], 10)

        .padding(.top)
        .task {
            // Workaround to overcome the limitations of SwiftUI's launch screen feature.
            try? await Task.sleep(for: Duration.seconds(1))
            launchScreenStateManager.dismissLaunchScreen()
            
            // Fetch data on appear
            Task {
                // Fetch data
                await viewModel.fetchAccountData()
            }
            Task {
                // Fetch data
                await viewModel.fetchAccountTransactions()
            }
        }
        
        // Alert popup
        .alert(isPresented: $showAlert) {
            // Alert content
            Alert(
                title: Text(hasPurchased ? "Cancel your Purchase" : "Unlock Premium Features"),
                message: Text(hasPurchased ? "Do you want to Cancel some of your unused purchases?" : "Do you want to unlock premium features?"),
                primaryButton: .default(Text("OK")) {
                    print("Clicked")
                    hasPurchased = !hasPurchased
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(LaunchScreenStateManager())
    }
}
