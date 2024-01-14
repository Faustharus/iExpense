//
//  ContentView.swift
//  iExpense
//
//  Created by Damien Chailloleau on 01/12/2023.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expenses]
    
    @State private var path = [Expenses]()
    @State private var sortOrder = [
        SortDescriptor(\Expenses.name),
        SortDescriptor(\Expenses.amount)
    ]
    @State private var showingAddExpense: Bool = false
    @State private var showingAll: Bool = true
    @State private var showingCategory: Bool = false
    
    @State private var expense = Expenses()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                if showingAll {
                    Section("All") {
                        ExpenseView(expenseCategory: "Personal", sortOrder: sortOrder)
                        ExpenseView(expenseCategory: "Business", sortOrder: sortOrder)
                    }
                } else {
                    Section(showingCategory ? "Personal" : "Business") {
                        ExpenseView(expenseCategory: showingCategory ? "Personal" : "Business", sortOrder: sortOrder)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu("Category", systemImage: "tray.full") {
                        Button("All") {
                            showingAll = true
                        }
                        
                        Button("Personal") {
                            showingCategory = true
                            showingAll = false
                        }
                        
                        Button("Business") {
                            showingCategory = false
                            showingAll = false
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("", selection: $sortOrder) {
                                Text("Sort by Name")
                                    .tag([
                                        SortDescriptor(\Expenses.name),
                                        SortDescriptor(\Expenses.amount)
                                    ])
                                
                                Text("Sort by Amount")
                                    .tag([
                                        SortDescriptor(\Expenses.amount),
                                        SortDescriptor(\Expenses.name)
                                    ])
                            }
                        }
                        
                        Button {
                            showingAddExpense = true
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expense)
            }
            .navigationDestination(for: Expenses.self) { expense in
                DetailView(expense: expense)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Expenses.self)
}
