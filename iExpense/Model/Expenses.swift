//
//  Expenses.swift
//  iExpense
//
//  Created by Damien Chailloleau on 20/12/2023.
//

import SwiftData
import Foundation

@Model
class Expenses {
    var name: String
    var type: String
    var amount: Decimal
    
    init(name: String, type: String, amount: Decimal) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
