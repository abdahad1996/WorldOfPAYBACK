//
//  TransactionView.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 14.01.24.
//
//
import SwiftUI

public struct TransactionfilterView: View {
    @Binding var selectedFilter: Int
    var categories:[Int]
    
    public var body: some View {
        Picker("Filter", selection: $selectedFilter) {
            ForEach(categories, id: \.self) { type in
                if type == -1 {
                    Text("All")
                }else{
                    Text("Category \(type)")
                }
                 
            }
        }.pickerStyle(SegmentedPickerStyle())
         .padding()
    }
    
}


struct TransactionfilterView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionfilterView(selectedFilter: .constant(1), categories: [1,2,3,4])
    }
}
