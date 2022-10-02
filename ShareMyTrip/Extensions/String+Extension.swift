//
//  String+Extension.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/02.
//

import Foundation

extension String {
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
}
