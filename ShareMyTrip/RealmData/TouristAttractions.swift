//
//  TouristAttractions.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/26.
//

import Foundation

import RealmSwift

final class TouristAttractions: Object, Codable {
    @Persisted var name: String
    @Persisted var address: String
    @Persisted var introduction: String
    @Persisted var admin: String
    @Persisted var phoneNumber: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(name: String, address: String, introduction: String, admin: String, phoneNumber: String, latitude: Double, longitude: Double) {
        self.init()
        self.name = name
        self.address = address
        self.introduction = introduction
        self.admin = admin
        self.phoneNumber = phoneNumber
        self.latitude = latitude
        self.longitude = longitude
    }
    
    enum RootKeys: String, CodingKey {
        case response
    }
    
    enum ResponseKeys: String, CodingKey {
        case body
    }
    
    enum BodyKeys: String, CodingKey {
        case items
    }
    
    enum ItemsKeys: String, CodingKey {
        case name = "trrsrtNm"
        case address = "rdnmadr"
        case introduction = "trrsrtIntrcn"
        case admin = "institutionNm"
        case phoneNumber
        case latitude
        case longitude
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ItemsKeys.self)
        try container.encode(self._name, forKey: .name)
        try container.encode(self._address, forKey: .address)
        try container.encode(self._introduction, forKey: .introduction)
        try container.encode(self._admin, forKey: .admin)
        try container.encode(self._phoneNumber, forKey: .phoneNumber)
        try container.encode(self._latitude, forKey: .latitude)
        try container.encode(self._longitude, forKey: .longitude)
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        let response = try container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .response)
        
        let body = try response.nestedContainer(keyedBy: BodyKeys.self, forKey: .body)
        
        var itemsContainer = try body.nestedUnkeyedContainer(forKey: .items)
        
        var itemsArray = [Persisted<String>]()
        while !itemsContainer.isAtEnd {
            let itemCountContainer = try itemsContainer.nestedContainer(keyedBy: ItemsKeys.self)
            itemsArray.append(try itemCountContainer.decode(Persisted<String>.self, forKey: .name))
        }
        guard let item = itemsArray.first else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: itemsContainer.codingPath + [BodyKeys.items], debugDescription: "items cannot be empty"))
        }
        
        
        
        
        print(itemsArray)
        self._name = item
//        let itemContainer = try itemsContainer.nestedContainer(keyedBy: ItemsKeys.self)
//
//        self._name = try itemContainer.decode(Persisted<String>.self, forKey: .name)
//        self._address = try itemContainer.decode(Persisted<String>.self, forKey: .address)
//        self._introduction = try itemContainer.decode(Persisted<String>.self, forKey: .introduction)
//        self._admin = try itemContainer.decode(Persisted<String>.self, forKey: .admin)
//        self._phoneNumber = try itemContainer.decode(Persisted<String>.self, forKey: .phoneNumber)
//        self._latitude = try itemContainer.decode(Persisted<String>.self, forKey: .latitude)
//        self._longitude = try itemContainer.decode(Persisted<String>.self, forKey: .longitude)
    }
    
}
