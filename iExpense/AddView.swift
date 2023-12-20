//
//  AddView.swift
//  iExpense
//
//  Created by Damien Chailloleau on 02/12/2023.
//

import SwiftData
import SwiftUI

enum Types: String, CaseIterable {
    case Personal, Business
}

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var type: Types = .Personal
    @State private var amount: Decimal = 0.0
    
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
                
                Button("Close") {
                    dismiss()
                }
                
            }
            .navigationTitle("Add New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    let newExpense = Expenses(name: name, type: type.rawValue, amount: amount)
                    modelContext.insert(newExpense)
                    dismiss()
                } label: {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
                .disabled(name.isEmpty || amount.isZero)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    AddView()
}
