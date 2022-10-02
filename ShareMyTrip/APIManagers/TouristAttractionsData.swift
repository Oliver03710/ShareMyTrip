//
//  TouristAttractionsData.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/26.
//

import Foundation

struct TouristAttraction: Codable {
    let response: Response
}

struct Response: Codable {
    let body: Body
}

struct Body: Codable {
    let items: [Items]
}

struct Items: Codable {
    let name, address, introduction, admin, phoneNumber, latitude, longitude: String
    
    enum CodingKeys: String, CodingKey {
        case name = "trrsrtNm"
        case address = "rdnmadr"
        case introduction = "trrsrtIntrcn"
        case admin = "institutionNm"
        case phoneNumber
        case latitude
        case longitude
    }
}



