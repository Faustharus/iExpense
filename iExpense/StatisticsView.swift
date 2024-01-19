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
    
    @State private var localArray = [ChartsData]()
    
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
                
                Section("Launch a request") {
                    Button {
                        Task {
                            await requestData()
                        }
                    } label: {
                        Text("Request Data")
                    }
                    .buttonStyle(.borderedProminent)
                    .offset(x: 80)
                }
            }
            
            Chart {
                ForEach(localArray) { item in
                    ForEach(item.exchangeData.sorted(by: <), id: \.key) { (key, val) in
                        LineMark(x: .value("Date", item.date), y: .value("Value", val))
                            .foregroundStyle(by: .value("Currency", key))
                    }
                }
            }
            .frame(height: 180)
            .padding()
        }
    }
}

#Preview {
    StatisticsView()
}

// MARK: Functions
extension StatisticsView {
    
    func requestData() async -> Void {
        let rates = await statisticsVM.loadExchangeRates()
        let currentDate = statisticsVM.currentDate
        let newArray: () = localArray.append(ChartsData(date: currentDate, exchangeData: rates))
        return newArray
    }
    
}
