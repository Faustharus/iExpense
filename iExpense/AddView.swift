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
    @State private var selectedImage: Data?
    
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
                    .keyboardType(.decimalPad)
                
                if let selectedImage,
                   let uiImage = UIImage(data: selectedImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                }
                
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Label("Add Photo", systemImage: "photo")
                }
//                
                if selectedImage != nil || pickerItem != nil {
                    Button(role: .destructive) {
                        withAnimation {
                            selectedImage = nil
                            pickerItem = nil
                        }
                    } label: {
                        Label("Remove Picture", systemImage: "xmark")
                            .foregroundStyle(.red)
                    }
                }
                
                Button("Close") {
                    dismiss()
                }
                
            }
            .navigationTitle("Add New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    let newExpense = Expenses(name: name, type: type.rawValue, currency: currencyName, amount: amount, image: selectedImage)
                    modelContext.insert(newExpense)
                    dismiss()
                } label: {
                    Label("Save", systemImage: "")
                }
                .disabled(name.isEmpty || amount.isZero)
            }
            .navigationBarBackButtonHidden(true)
            .task(id: pickerItem) {
                if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                    selectedImage = data
                }
            }
        }
    }
}

#Preview {
    AddView()
}
