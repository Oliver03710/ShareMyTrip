//
//  CustomAnnotations.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/16.
//

import Foundation

enum CustomAnnotations: String, CaseIterable {
    case one
    
    var images: String {
        switch self {
        case .one: return "customAnno1"
        }
    }
}
