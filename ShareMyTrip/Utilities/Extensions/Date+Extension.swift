//
//  Date+Extension.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/29.
//

import UIKit

extension Date {
    
    func toString(withFormat format: String = "yyMMdd_HH:mm") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
    
}
