//
//  CurrentTrip.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/19.
//

import Foundation

import RealmSwift

final class CurrentTrip: EmbeddedObject, Codable {
    
    @Persisted var name: String
    @Persisted var address: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var turn: Int
    
    convenience init(name: String, address: String, latitude: Double, longitude: Double, turn: Int) {
        self.init()
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.turn = turn
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
        try container.encode(self.turn, forKey: .turn)
    }
    
    private enum CodingKeys: CodingKey {
        case name
        case address
        case latitude
        case longitude
        case turn
    }
}
