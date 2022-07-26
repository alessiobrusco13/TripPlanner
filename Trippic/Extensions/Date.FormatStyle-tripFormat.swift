//
//  Date-tripFormatStyle.swift
//  Trippic
//
//  Created by Alessio Garzia Marotta Brusco on 25/07/22.
//

import Foundation

extension Trip {
    static func dateFormat(_ date: Date) -> Date.FormatStyle {
        let dateYear = Calendar.current.dateComponents([.year], from: date)
        let currentYear = Calendar.current.dateComponents([.year], from: .now)
        
        if dateYear == currentYear {
            return .dateTime.day().month()
        } else {
            return .dateTime.day().month().year()
        }
    }
}


