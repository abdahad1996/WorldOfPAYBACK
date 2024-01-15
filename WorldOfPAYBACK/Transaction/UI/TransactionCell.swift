//
//  TransactionView.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 14.01.24.
//
//
import SwiftUI
public struct TransactionCell: View {
     let viewModel: TransactionCellViewModel

    public init( viewModel: TransactionCellViewModel) {
        self.viewModel =  viewModel
    }

    public var body: some View {
//        VStack(alignment: .leading) {
            ZStack(alignment: .center) {
                VStack(alignment: .leading){
                    HStack {
                        Text(viewModel.partnerDisplayName)
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            .foregroundColor( .white)
                            
                        if let description = viewModel.description {
                            Text(description)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                                .foregroundColor(.white)
       
                        }
                        
                        
                        Spacer()

                    }
                    Text(viewModel.bookingDate).font(.title2).foregroundColor(.white)
                    HStack(spacing:3){
                        Text("Amount: \(viewModel.amount) \(viewModel.currency)").font(.title3)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            .foregroundColor( .blue)
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke( Color(uiColor: .systemBackground), lineWidth: 1)
                            )
                    }
                   
                    

                }
               
                .padding()
        }.background(
            LinearGradient(
                gradient: Gradient(colors: [Color.red, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

struct TransactionCell_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCell(viewModel: TransactionCellViewModel(transaction: makeTransaction()))
    }
    
    private static func makeTransaction() -> TransactionItem{
        return TransactionItem(partnerDisplayName: "REWE Group",bookingDate: Date(timeIntervalSince1970: 1577881882), description: "Punkte sammeln", amount: 124, currency: "PBP",category: 1)
    }
    
}
