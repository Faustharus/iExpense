//
//  AddView.swift
//  iExpense
//
//  Created by Damien Chailloleau on 02/12/2023.
//

import SwiftUI

enum Types: String, CaseIterable {
    case Personal, Business
}

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var type: Types = .Personal
    @State private var amount: Double = 0.0
    
    let expenses: Expenses
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .keyboardType(.default)
                
                Picker("Type", selection: $type) {
                    ForEach(Types.allCases, id: \.self) { item in
                        Text(item.rawValue)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "EUR"))
                
            }
            .navigationTitle("Add New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    let expense = ExpenseItem(name: name, type: type.rawValue, value: amount)
                    expenses.items.append(expense)
                    dismiss()
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
                .disabled(name.isEmpty || amount.isZero)
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
