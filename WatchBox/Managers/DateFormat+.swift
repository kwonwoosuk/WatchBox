//
//  DateFormat+.swift
//  WatchBox
//
//  Created by 권우석 on 1/28/25.
//

import Foundation


extension Date {
    func dateFormatting() -> String {
        let dateFormatter = DateFormatter()
        let now = Date()
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter.string(from: now)
    }
}

extension String {
    static func formatDate(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"
        
        if let convertedDate = inputFormatter.date(from: date) {
            return outputFormatter.string(from: convertedDate)
        }
        return date
    }
}
