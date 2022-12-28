//
//  SearchData.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/02.
//

import Foundation
import CoreLocation

struct SearchData: Codable {
    let documents: [Documents]
    let meta: Meta
}

struct Documents: Codable {
    let name, address, category, placeURL, latitude, longitude: String
    
    enum CodingKeys: String, CodingKey {
        case name = "place_name"
        case address = "road_address_name"
        case category = "category_group_name"
        case placeURL = "place_url"
        case latitude = "y"
        case longitude = "x"
    }
}

struct Meta: Codable {
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}

struct SearchResults {
    let name: String
    let address: String
    let category: String
    let placeURL: String
    let coordinates: CLLocationCoordinate2D
}
