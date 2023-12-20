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
    @State private var path = [Expenses]()
    @Query var expenses: [Expenses]
    @State private var showingAddExpense: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
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
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView()
            }
            .navigationDestination(for: Expenses.self) { expense in
                DetailView(expense: expense)
            }
        }
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    
    func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            let expense = expenses[offset]
            modelContext.delete(expense)
        }
    }
    
}
