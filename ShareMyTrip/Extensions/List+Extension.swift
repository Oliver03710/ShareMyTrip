//
//  List+Extension.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/25.
//

import Foundation

import RealmSwift

extension List {
    
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
    
}
