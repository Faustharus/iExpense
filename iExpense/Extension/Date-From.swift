//
//  Date-From.swift
//  iExpense
//
//  Created by Damien Chailloleau on 19/01/2024.
//

import Foundation

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
