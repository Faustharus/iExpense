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
    
    let currencies = ["EUR", "USD", "CAD", "AUD", "JPY", "CNY", "GBP", "BRL", "ZAF", "AED", "INR", "KRW"]
    
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
                
                Picker("Currency", selection: $currencyName) {
                    ForEach(currencies, id: \.self) { item in
                        Text("\(item)")
                    }
                }
                .pickerStyle(.wheel)
                
                TextField("Amount", value: $amount, format: .currency(code: "\(currencyName)"))
                
                PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
                
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
            .onChange(of: pickerItem) {
                Task {
                    selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                }
            }
            .toolbar {
                Button {
                    let newExpense = Expenses(name: name, type: type.rawValue, currency: currencyName, amount: amount)
                    modelContext.insert(newExpense)
                    dismiss()
                } label: {
                    Label("Save", systemImage: "")
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
