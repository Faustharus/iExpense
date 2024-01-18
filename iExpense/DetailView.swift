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
    
    @State private var toDelete: Bool = false
    
    let expense: Expenses
    
    var body: some View {
        VStack {
            ScrollView {
                HStack(spacing: 0) {
                    Text("Category :")
                        .font(.title2)
                    
                    Spacer().frame(width: 100)
                    
                    Text("\(expense.type)")
                        .font(.title.bold())
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                VStack {
                    if expense.image == nil {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1.5)
                            VStack {
                                ContentUnavailableView {
                                    Label("No Justification", systemImage: "photo.fill")
                                } description: {
                                    Text("You didn't post the proof of your spending")
                                }
                            }
                        }
                        .frame(height: 300)
                        .padding(.horizontal)
                    } else {
                        if let selectedImage = expense.image ?? nil,
                           let uiImage = UIImage(data: selectedImage) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                        }
                    }
                }
                
                HStack(spacing: 0) {
                    Text("Amount : ")
                        .font(.title2)
                    
                    Spacer().frame(width: 100)
                    
                    Text("\(expense.amount, format: .currency(code: "\(expense.currency)"))")
                        .font(.title.bold())
                }
                .padding([.horizontal, .vertical], 10)
                
                Spacer()
                
                if expense.summaryText?.isEmpty == nil {
                    Text("No summary text")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Summary:")
                            .font(.title.bold().italic())
                        Text("\(expense.summaryText ?? "")")
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 10)
                }
            }
            .navigationTitle(expense.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.toDelete = true
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                }
            }
            .alert(isPresented: $toDelete) {
                Alert(title: Text("Are you sure ?"), message: Text("This action is irreversible"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .destructive(Text("Delete"), action: {
                    modelContext.delete(expense)
                    dismiss()
                }))
            }
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Expenses.self, configurations: config)
        let dummyExpense = Expenses(name: "Groceries", type: "Personal", currency: "EUR", amount: 15.87, summaryText: "It is recommended to use ContentUnavailableView in situations where a view’s content cannot be displayed. That could be caused by a network error, a list without items, a search that returns no results etc. You create an ContentUnavailableView in its simplest form, by providing a label and some additional content such as a description or a call to action", image: nil)
        
        return NavigationStack {
            DetailView(expense: dummyExpense)
                .modelContainer(container)
        }
    } catch {
        return Text("Failed to return the preview : \(error.localizedDescription)")
    }
}
