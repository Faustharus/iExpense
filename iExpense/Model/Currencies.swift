//
//  Currencies.swift
//  iExpense
//
//  Created by Damien Chailloleau on 11/01/2024.
//

import Foundation

struct Currencies: Codable, Hashable, Equatable {
    let continent: String
    let countries: [Country]
}

struct Country: Codable, Hashable, Equatable {
    let acronym, name: String
}
