//
//  StatisticsViewModel.swift
//  iExpense
//
//  Created by Damien Chailloleau on 16/01/2024.
//

import SwiftUI

@MainActor
final class StatisticsViewModel: ObservableObject {
    
    @Published var enterValue: Decimal = 1.0
    @Published var selection: String = ""
    @Published var exchanges = [String: Decimal]()
    @Published var currentDate: Date = .now
    
    private let ratesAPI = ExchangeRateAPI.shared
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents =  calendar.dateComponents([.year, .month, .day], from: Date.distantPast)
        let endComponents = calendar.dateComponents([.year, .month, .day], from: Date.now)
        return calendar.date(from: startComponents)!
        ...
        calendar.date(from: endComponents)!
    }()
    
    func loadExchangeRates() async {
        do {
            exchanges = try await ratesAPI.fetch(adding: dateStringConverter, with: selection)
            print("\(exchanges.keys): \(exchanges.values)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var dateStringConverter: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: currentDate)
    }
    
}
