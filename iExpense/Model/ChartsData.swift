//
//  ChartsData.swift
//  iExpense
//
//  Created by Damien Chailloleau on 19/01/2024.
//

import Foundation

struct ChartsData: Identifiable {
    let id = UUID()
    var date: Date
    var exchangeData: [String: Decimal]
}
