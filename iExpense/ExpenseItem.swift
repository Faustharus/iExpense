//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Damien Chailloleau on 02/12/2023.
//

import Foundation

struct ExpenseItem: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    let name: String
    let type: String
    let value: Double
}
