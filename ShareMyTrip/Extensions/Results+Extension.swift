//
//  Results+Extension.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/25.
//

import Foundation

import RealmSwift

extension Results {
    
  func toArray() -> [Element] {
    return compactMap { $0 }
  }
    
}
