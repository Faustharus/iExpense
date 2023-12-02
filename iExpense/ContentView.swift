//
//  ContentView.swift
//  iExpense
//
//  Created by Damien Chailloleau on 01/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
            
                Section("Personal") {
                    if expenses.items.isEmpty {
                        ContentUnavailableView("No Personal Expenses", systemImage: "folder.badge.plus", description: Text("Tap the top right corner of the screen to add an Expense"))
                            .symbolVariant(.fill)
                    } else {
                        ForEach(expenses.items, id: \.id) { item in
                            if item.type == "Personal" {
                                NavigationLink(value: item) {
                                    HStack {
                                        Text(item.name)
                                            .font(.system(size: 22, weight: .bold, design: .serif))
                                        
                                        Spacer()
                                        
                                        Text("\(item.value, format: .currency(code: "EUR"))")
                                            .font(.system(size: 18, weight: .semibold, design: .serif))
                                            .foregroundStyle(item.value >= 200 ? .red : item.value >= 100 ? .orange : item.value >= 50 ? .green : .black)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: removeItems)
                    }
                }
                
                Section("Business") {
                    if expenses.items.isEmpty {
                        ContentUnavailableView("No Business Expenses", systemImage: "folder.badge.plus", description: Text("Tap the top right corner of the screen to add an Expense"))
                            .symbolVariant(.fill)
                    } else {
                        ForEach(expenses.items, id: \.id) { item in
                            if item.type == "Business" {
                                NavigationLink(value: item) {
                                    HStack {
                                        Text(item.name)
                                            .font(.system(size: 22, weight: .bold, design: .serif))
                                        
                                        Spacer()
                                        
                                        Text("\(item.value, format: .currency(code: "EUR"))")
                                            .font(.system(size: 18, weight: .semibold, design: .serif))
                                            .foregroundStyle(item.value >= 200 ? .red : item.value >= 100 ? .orange : item.value >= 50 ? .green : .black)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: removeItems)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
            .navigationDestination(for: ExpenseItem.self) { expense in
                DetailView(expenses: expense)
            }
        }
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
}
