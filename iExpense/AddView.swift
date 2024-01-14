//
//  AddView.swift
//  iExpense
//
//  Created by Damien Chailloleau on 02/12/2023.
//

import PhotosUI
import SwiftData
import SwiftUI

enum Types: String, CaseIterable {
    case Personal, Business
}

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var currencyName: String = "EUR"
    @State private var type: Types = .Personal
    @State private var amount: Decimal = 0.0
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    @Bindable var expenses: Expenses
    
    let currencies = ["EUR", "USD", "CAD", "AUD", "JPY", "CNY", "GBP", "BRL", "ZAF", "AED", "INR", "KRW"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $expenses.name)
                    .keyboardType(.default)
                
                Picker("Type", selection: $expenses.type) {
                    ForEach(Types.allCases, id: \.self) { item in
                        Text(item.rawValue)
                    }
                }
                
                Picker("Currency", selection: $expenses.currency) {
                    ForEach(currencies, id: \.self) { item in
                        Text("\(item)")
                    }
                }
                .pickerStyle(.wheel)
                
                TextField("Amount", value: $expenses.amount, format: .currency(code: "\(expenses.currency)"))
                
                PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
                
                Button(role: .destructive) {
                    selectedImage = nil
                    pickerItem = nil
                } label: {
                    Text("Remove Photo")
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedImage == nil || pickerItem == nil)
                
                Section {
                    selectedImage?
                        .resizable()
                        .scaledToFit()
                }
                
                Button("Close") {
                    dismiss()
                }
                
            }
            .navigationTitle("Add New Expense")
            .navigationBarTitleDisplayMode(.inline)
//            .onChange(of: pickerItem) {
//                Task {
//                    selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
//                }
//            }
            .toolbar {
                Button {
                    let newExpense = Expenses(name: expenses.name, type: expenses.type, currency: expenses.currency, amount: expenses.amount, image: expenses.image)
                    modelContext.insert(newExpense)
                    dismiss()
                } label: {
                    Label("Save", systemImage: "")
                }
                .disabled(name.isEmpty || amount.isZero)
            }
            .navigationBarBackButtonHidden(true)
            .task(id: selectedImage) {
                if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                    expenses.image = data
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Expenses.self, configurations: config)
        let dummyExpense = Expenses()
        return AddView(expenses: dummyExpense)
    } catch {
        return Text("Failed to return the preview: \(error.localizedDescription)")
    }
    
//    AddView(expenses: Expenses(name: "", type: "", currency: "", amount: 0.00, image: nil))
}
