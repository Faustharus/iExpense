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

//extension Date {
//    static func from(year: Int, month: Int, day: Int) -> Date {
//        let components = DateComponents(year: year, month: month, day: day)
//        return Calendar.current.date(from: components)!
//    }
//}

struct StatisticsView: View {
    
    @StateObject var statisticsVM = StatisticsViewModel()
    
    @State private var localArray = [TestChart]()
    
//    let arrayChart: [TestChart] = [
//        .init(date: Date.from(year: 2024, month: 01, day: 1), finalData: ["EUR": 1.10]),
//        .init(date: Date.from(year: 2023, month: 12, day: 1), finalData: ["EUR": 1.09]),
//        .init(date: Date.from(year: 2023, month: 11, day: 1), finalData: ["EUR": 1.02]),
//        .init(date: Date.from(year: 2023, month: 10, day: 1), finalData: ["EUR": 1.05]),
//        .init(date: Date.from(year: 2023, month: 09, day: 1), finalData: ["EUR": 1.01]),
//        .init(date: Date.from(year: 2023, month: 08, day: 1), finalData: ["EUR": 1.01]),
//        .init(date: Date.from(year: 2023, month: 07, day: 1), finalData: ["EUR": 1.04]),
//        .init(date: Date.from(year: 2023, month: 06, day: 1), finalData: ["EUR": 1.05]),
//        .init(date: Date.from(year: 2023, month: 05, day: 1), finalData: ["EUR": 1.07]),
//        .init(date: Date.from(year: 2023, month: 04, day: 1), finalData: ["EUR": 1.09]),
//        .init(date: Date.from(year: 2023, month: 03, day: 1), finalData: ["EUR": 1.08]),
//        .init(date: Date.from(year: 2023, month: 02, day: 1), finalData: ["EUR": 1.10]),
//        .init(date: Date.from(year: 2023, month: 01, day: 1), finalData: ["EUR": 1.06]),
//        .init(date: Date.from(year: 2024, month: 01, day: 1), finalData: ["USD": 1.15]),
//        .init(date: Date.from(year: 2023, month: 12, day: 1), finalData: ["USD": 1.29]),
//        .init(date: Date.from(year: 2023, month: 11, day: 1), finalData: ["USD": 1.20]),
//        .init(date: Date.from(year: 2023, month: 10, day: 1), finalData: ["USD": 1.35]),
//        .init(date: Date.from(year: 2023, month: 09, day: 1), finalData: ["USD": 1.19]),
//        .init(date: Date.from(year: 2023, month: 08, day: 1), finalData: ["USD": 1.51]),
//        .init(date: Date.from(year: 2023, month: 07, day: 1), finalData: ["USD": 1.64]),
//        .init(date: Date.from(year: 2023, month: 06, day: 1), finalData: ["USD": 1.05]),
//        .init(date: Date.from(year: 2023, month: 05, day: 1), finalData: ["USD": 1.27]),
//        .init(date: Date.from(year: 2023, month: 04, day: 1), finalData: ["USD": 1.09]),
//        .init(date: Date.from(year: 2023, month: 03, day: 1), finalData: ["USD": 1.78]),
//        .init(date: Date.from(year: 2023, month: 02, day: 1), finalData: ["USD": 1.10]),
//        .init(date: Date.from(year: 2023, month: 01, day: 1), finalData: ["USD": 1.16]),
//        .init(date: Date.from(year: 2023, month: 01, day: 1), finalData: ["USD": 1.16]),
//    ]
    
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
                
                Section {
                    Button {
//                        localArray.append(statisticsVM.selection)
//                        let _ = print(localArray)
//                        statisticsVM.selection = ""
                    } label: {
                        Text("Add Currency")
                    }
                    .buttonStyle(.bordered)
                    .disabled(statisticsVM.selection.count != 3 || statisticsVM.selection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                    Button(role: .destructive) {
//                        localArray = []
                    } label: {
                        Text("Reset")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            Chart {
                ForEach(localArray) { item in
                    ForEach(item.finalData.sorted(by: <), id: \.key) { (key, val) in
                        LineMark(x: .value("Date", item.date), y: .value("Value", val))
                            .foregroundStyle(by: .value("Currency", key))
                    }
                }
            }
            .frame(height: 180)
            .padding()
            
//            Chart {
//                ForEach(arrayChart) { item in
//                    ForEach(item.finalData.sorted(by: <), id: \.key) { (key, val) in
//                        BarMark(x: .value("Date", item.date, unit: .month), y: .value("Value", val))
//                            .foregroundStyle(by: .value("Currency", key))
//                    }
//                }
//            }
//            .frame(height: 180)
//            .padding()
            
            Button {
                Task {
//                 await loadData()
                }
                let _ = print(localArray)
            } label: {
                Text("Load Data")
            }
            
            Button {
//                localArray.append(loadData)
                Task {
                    await pushData()
                }
            } label: {
                Text("Test Push Array")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    StatisticsView()
}

extension StatisticsView {

//    func loadData() async {
//        await statisticsVM.loadExchangeRates()
//    }
    
    func pushData() async -> Void {
        let rates = await statisticsVM.loadExchangeRates()
        let currentDate = statisticsVM.currentDate
        let newArray: () = localArray.append(TestChart(date: currentDate, finalData: rates))
        return newArray
    }
    
}
