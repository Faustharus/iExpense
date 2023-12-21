//
//  ExpenseView.swift
//  iExpense
//
//  Created by Damien Chailloleau on 20/12/2023.
//

import SwiftData
import SwiftUI

struct ExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expenses]
    
    init(expenseCategory: String, sortOrder: [SortDescriptor<Expenses>]) {
        _expenses = Query(filter: #Predicate<Expenses> { expense in
            expense.type == expenseCategory
        }, sort: sortOrder)
    }
    
    var body: some View {
        ForEach(expenses) { item in
            NavigationLink(value: item) {
                HStack {
                    Text(item.name)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                    
                    Spacer()
                    
                    Text("\(item.amount, format: .currency(code: "EUR"))")
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .foregroundStyle(item.amount >= 200 ? .red : item.amount >= 100 ? .orange : item.amount >= 50 ? .green : .black)
                }
            }
        }
        .onDelete(perform: removeItems)
        
    }
}

#Preview {
    ExpenseView(expenseCategory: Types.Personal.rawValue, sortOrder: [SortDescriptor(\Expenses.type)])
        .modelContainer(for: Expenses.self)
}

// MARK: Functions
extension ExpenseView {
    
    func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            let expense = expenses[offset]
            modelContext.delete(expense)
        }
    }
    
}
