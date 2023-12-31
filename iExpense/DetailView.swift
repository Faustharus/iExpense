//
//  DetailView.swift
//  iExpense
//
//  Created by Damien Chailloleau on 02/12/2023.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    let expense: Expenses
    
    var body: some View {
        VStack {
            Text("Category: \(expense.type)")
            Text("Amount: \(expense.amount, format: .currency(code: "EUR"))")
            
            Button("Delete this Expense", role: .destructive) {
                modelContext.delete(expense)
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle(expense.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Expenses.self, configurations: config)
        let dummyExpense = Expenses(name: "Groceries", type: "Personal", amount: 15.87)
        
        return DetailView(expense: dummyExpense)
            .modelContainer(container)
    } catch {
        return Text("Failed to return the preview : \(error.localizedDescription)")
    }
}
