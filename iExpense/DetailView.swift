//
//  DetailView.swift
//  iExpense
//
//  Created by Damien Chailloleau on 02/12/2023.
//

import SwiftUI

struct DetailView: View {
    let expenses: ExpenseItem
    
    var body: some View {
        VStack {
            Text("Category: \(expenses.type)")
            Text("Amount: \(expenses.value, format: .currency(code: "EUR"))")
        }
        .navigationTitle(expenses.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    DetailView(expenses: ExpenseItem(name: "Test", type: "Personal", value: 10.0))
}
