//
//  Zodiac.swift
//  Notter
//
//  Created by Gerald on 2024-08-13.
//

import Foundation

func getZodiacSign(from dateString: String) -> String {
    
    let components = dateString.split(separator: "-")
    guard components.count == 3,
          let year = Int(components[0]),
          let month = Int(components[1]),
          let day = Int(components[2]),
          year >= 1,
          (1...12).contains(month),
          (1...31).contains(day) else {
        return ""
    }

    let zodiacSigns = [
        (1, 20, "aquarius"), (2, 19, "pisces"), (3, 21, "aries"),
        (4, 20, "taurus"), (5, 21, "gemini"), (6, 21, "cancer"),
        (7, 23, "leo"), (8, 23, "virgo"), (9, 23, "libra"),
        (10, 23, "scorpio"), (11, 22, "sagittarius"), (12, 22, "capricorn")
    ]

    let monthDay = (month, day)
    for (i, (startMonth, startDay, sign)) in zodiacSigns.enumerated() {
        let endDate = zodiacSigns[(i + 1) % 12]
        if (monthDay >= (startMonth, startDay) && startMonth == month) ||
           (monthDay < (endDate.0, endDate.1) && endDate.0 == month) {
            return sign
        }
    }

    return ""
}
