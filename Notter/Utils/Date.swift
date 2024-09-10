//
//  DateInitializer.swift
//  Notter
//
//  Created by Gerald on 2024-08-11.
//

import Foundation
func getCurrentLocalDate() -> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = .current
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: currentDate)
}

func stringToDate(_ dateString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    if let date = dateFormatter.date(from: dateString) {
        return date
    } else {
        return Date()
    }
}

func dateToString(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
}
