//
//  Expenses.swift
//  iExpense
//
//  Created by Damien Chailloleau on 20/12/2023.
//

import SwiftData
import SwiftUI

@Model
final class Expenses {
    var name: String
    var type: String
    var currency: String
    var amount: Decimal
    
    @Attribute(.externalStorage)
    var image: Data?
    
    init(name: String = "", type: String = "", currency: String = "", amount: Decimal = 0.00, image: Data? = nil) {
        self.name = name
        self.type = type
        self.currency = currency
        self.amount = amount
        self.image = image
    }
}
