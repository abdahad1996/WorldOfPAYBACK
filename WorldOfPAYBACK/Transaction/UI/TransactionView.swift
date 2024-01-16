//
//  TransactionView.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 14.01.24.
//
//
import SwiftUI

public struct TransactionsView<TransactionCell: View, TransactionFilterView: View, TotalCountView:View>: View {
    @StateObject var viewModel: TransactionViewModel
    let showTransactionDetails: (TransactionItem) -> Void
    let transactionCell: (TransactionItem) -> TransactionCell
    let transactionFilterView: (Binding<Int>,[Int]) -> TransactionFilterView
    let totalCountView:(Binding<Int>) -> TotalCountView
    
    @StateObject var monitor = Monitor()

    public init(
        viewModel: TransactionViewModel,
        showTransactionDetails: @escaping (TransactionItem) -> Void,
        transactionCell: @escaping (TransactionItem) -> TransactionCell,
        transactionFilterView: @escaping (Binding<Int>,[Int]) -> TransactionFilterView,
        totalCountView: @escaping (Binding<Int>) -> TotalCountView

    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.showTransactionDetails = showTransactionDetails
        self.transactionCell = transactionCell
        self.transactionFilterView = transactionFilterView
        self.totalCountView = totalCountView
    }

    public var body: some View {
        if monitor.status == .connected {
            VStack {
                Text("No Internet Connection")
                Button(action: {
                    viewModel.getAllTransactions()
                }) {
                    Text("Retry")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                }
            }
        }else{
            VStack {
                switch viewModel.getTransactionsState {
                case .idle:
                    EmptyView()
                    
                case .isLoading:
                    ProgressView()
                    Spacer()
                    
                case .failure(let error):
                    //                Text(error.rawValue)
                    //                    .foregroundColor(.red)
                    //                Spacer()
                    VStack {
                        Text(error)
                        Button(action: {
                            viewModel.getAllTransactions()
                        }) {
                            Text("Retry")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                        }
                    }
                    
                case .success:
                    ScrollView(.vertical, showsIndicators: false) {
                        transactionFilterView($viewModel.filteredCategory,viewModel.UniqueCategories)
                            .padding(.bottom)
                        
                        LazyVStack {
                            ForEach(Array(viewModel.filteredTransactions.enumerated()),id: \.element) { index, transaction in
                                transactionCell(transaction)
                                    .background(Color(uiColor: .systemBackground))
                                    .cornerRadius(16)
                                    .frame(maxWidth: .infinity)
                                
                                    .aspectRatio(0.75, contentMode: .fit)
                                    .padding(4)
                                    .shadow(color: .gray, radius: 2)
                                    .onTapGesture {
                                        showTransactionDetails(transaction)
                                    }.accessibilityIdentifier("UICellVertical\(index)")
                            }
                            
                        }.accessibilityIdentifier("list")
                    }.overlay(FloatingView(count: $viewModel.totalAmount), alignment: .bottom)
                }
            }.refreshable {
                viewModel.getAllTransactions()
            }
            .padding(.horizontal)
            .task {
                guard viewModel.getTransactionsState == .idle else { return }
                
                viewModel.getAllTransactions()
            }
        }
    }
}

 

struct Transaction_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(viewModel: TransactionViewModel(transactionLoader: RemoteLoaderStub()), showTransactionDetails: {_ in}) { transactionItem in
            TransactionCell(viewModel: TransactionCellViewModel(transaction: transactionItem))
        } transactionFilterView: { selectedFilter, categories in
            TransactionfilterView(selectedFilter: selectedFilter, categories: categories)
        } totalCountView: { total in
            FloatingView(count: total)
        }

    }
    
    private static func makeTransactions() -> [TransactionItem] {
       [
        TransactionItem(partnerDisplayName: "REWE Group",bookingDate: Date(timeIntervalSince1970: 1577881882), description: "Punkte sammeln", amount: 124, currency: "PBP",category: 1),
          
        TransactionItem(partnerDisplayName: "dm-dogerie markt",bookingDate: Date(timeIntervalSince1970: 1598627222), description: "Punkte sammeln", amount: 1240, currency: "PBP",category: 1),
          
        TransactionItem(partnerDisplayName: "dm-dogerie markt", bookingDate:  Date(timeIntervalSince1970:  1668157145), description: nil, amount: 1240, currency: "PBP",category: 2),
           
       ]
   }
   private class RemoteLoaderStub:TransactionLoader{
        func load(completion: @escaping (TransactionLoader.Result) -> Void) {
            let transactions = makeTransactions()
            completion(.success(transactions))
        }
        
    }
}
