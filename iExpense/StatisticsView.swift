//
//  StatisticsView.swift
//  iExpense
//
//  Created by Damien Chailloleau on 16/01/2024.
//

import Charts
import SwiftUI

struct StatisticsView: View {
    
    @StateObject var statisticsVM = StatisticsViewModel()
    
    var body: some View {
        VStack {
            Form {
                Section("Define when") {
                    DisclosureGroup {
                        DatePicker("", selection: $statisticsVM.currentDate, in: statisticsVM.dateRange, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                    } label: {
                        Label("Select a date", systemImage: "calendar")
                    }
                }
                
                Section("Define an Amount") {
                    TextField("Initial Value at €1,00", value: $statisticsVM.enterValue, format: .currency(code: "EUR"))
                        .keyboardType(.decimalPad)
                        .submitLabel(.continue)
                }
                
                Section("Define your currencies") {
                    TextField("Ex: EUR,USD,GBP or JPY", text: $statisticsVM.selection)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .keyboardType(.alphabet)
                        .submitLabel(.done)
                }
            }
            
            Chart {
                LineMark(
                    x: .value("Value", 3),
                    y: .value("Currency", 10)
                )
                .foregroundStyle(by: .value("Test", "SF"))
            }
            .frame(maxWidth: 300, maxHeight: 300)
            .task {
                await loadData()
            }
            
            Button {
                Task {
                    await loadData()
                }
            } label: {
                Text("Load Data")
            }
        }
    }
}

#Preview {
    StatisticsView()
}

extension StatisticsView {
    
    func loadData() async {
        await statisticsVM.loadExchangeRates()
    }
    
}
