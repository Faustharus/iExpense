//
//  StatisticsView.swift
//  iExpense
//
//  Created by Damien Chailloleau on 16/01/2024.
//

import Charts
import SwiftUI

struct TestChart: Identifiable {
    let id = UUID()
    var date: Date
    var finalData: [String: Decimal]
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}

struct StatisticsView: View {
    
    @StateObject var statisticsVM = StatisticsViewModel()
    
    let arrayChart: [TestChart] = [
        .init(date: Date.from(year: 2024, month: 01, day: 1), finalData: ["EUR": 1.10]),
        .init(date: Date.from(year: 2023, month: 12, day: 1), finalData: ["EUR": 1.09]),
        .init(date: Date.from(year: 2023, month: 11, day: 1), finalData: ["EUR": 1.02]),
        .init(date: Date.from(year: 2023, month: 10, day: 1), finalData: ["EUR": 1.05]),
        .init(date: Date.from(year: 2023, month: 09, day: 1), finalData: ["EUR": 1.01]),
        .init(date: Date.from(year: 2023, month: 08, day: 1), finalData: ["EUR": 1.01]),
        .init(date: Date.from(year: 2023, month: 07, day: 1), finalData: ["EUR": 1.04]),
        .init(date: Date.from(year: 2023, month: 06, day: 1), finalData: ["EUR": 1.05]),
        .init(date: Date.from(year: 2023, month: 05, day: 1), finalData: ["EUR": 1.07]),
        .init(date: Date.from(year: 2023, month: 04, day: 1), finalData: ["EUR": 1.09]),
        .init(date: Date.from(year: 2023, month: 03, day: 1), finalData: ["EUR": 1.08]),
        .init(date: Date.from(year: 2023, month: 02, day: 1), finalData: ["EUR": 1.10]),
        .init(date: Date.from(year: 2023, month: 01, day: 1), finalData: ["EUR": 1.06]),
    ]
    
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
                ForEach(arrayChart) { item in
                    ForEach(item.finalData.sorted(by: <), id: \.key) { (key, val) in
                        BarMark(x: .value("Date", item.date, unit: .month), y: .value("Currency", val))
                    }
                    
                }
            }
            .frame(height: 180)
            
            Button {
                Task {
                    await loadData()
                }
            } label: {
                Text("Load Data")
            }
        }
        .task {
            await loadData()
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
