//
//  DateFormat+.swift
//  WatchBox
//
//  Created by 권우석 on 1/28/25.
//

import Foundation


extension Date {
    
    func signDateFormatting() -> String {
        
        let dateFormatter = DateFormatter()
        let now = Date()
        
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter.string(from: now)
    }
}
