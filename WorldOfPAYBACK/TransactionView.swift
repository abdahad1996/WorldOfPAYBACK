//
//  TransactionView.swift
//  WorldOfPAYBACK
//
//  Created by Abdul Ahad on 14.01.24.
//

import SwiftUI
import SwiftUI

struct TransactionView: View {
    @State private var selectedFilter: String = "All"

    let items = [
        Item(name: "Item 1", category: "Category A"),
        Item(name: "Item 2", category: "Category B"),
        Item(name: "Item 3", category: "Category A"),
        Item(name: "Item 3", category: "Category A"),

        // Add more items with different categories
    ]

    var filteredItems: [Item] {
        if selectedFilter == "All" {
            return items
        } else {
            return items.filter { $0.category == selectedFilter }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                    Text("All").tag("All")
                    Text("Category A").tag("Category A")
                    Text("Category B").tag("Category B")
                    // Add more categories to filter
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List(filteredItems, id: \.name) { item in
                    Text(item.name)
                }
                .navigationTitle("Filtered List")
            }
        }
    }
}

struct Item {
    let name: String
    let category: String
}

 

#Preview {
    TransactionView()
}
