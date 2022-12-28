//
//  TripHistory.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/19.
//

import Foundation

import RealmSwift

final class TripHistory: Object, Codable {
    
    private override init() { }
    
    @Persisted var tripName: String
    @Persisted var isTraveling: Bool
    @Persisted var trips = List<CurrentTrip>()
    @Persisted var companions = List<Companions>()
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(tripName: String, trips: [CurrentTrip], companions: [Companions]) {
        self.init()
        self.tripName = tripName
        self.trips.append(objectsIn: trips)
        self.companions.append(objectsIn: companions)
        self.isTraveling = true
    }
    
    private enum CodingKeys: String, CodingKey {
        case tripName, isTraveling, trips, companions
    }
    
    private enum TripsCodingKeys: String, CodingKey {
        case name, address, latitude, longitude, turn
    }

    private enum CompanionsCodingKeys: String, CodingKey {
        case companion, isBeingDeleted
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.tripName, forKey: .tripName)
        try container.encode(self.isTraveling, forKey: .isTraveling)
        
        let tripsContainer = container.superEncoder(forKey: .trips)
        try trips.encode(to: tripsContainer)
        
        let companionContainer = container.superEncoder(forKey: .companions)
        try companions.encode(to: companionContainer)
        
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tripName = try container.decode(String.self, forKey: .tripName)
        self.isTraveling = try container.decode(Bool.self, forKey: .isTraveling)
        
        var companiesContainer = try container.nestedUnkeyedContainer(forKey: .companions)
        
        var compArray = [(companion: String, isBeingDeleted: Bool)]()
        while !companiesContainer.isAtEnd {
            let itemCountContainer = try companiesContainer.nestedContainer(keyedBy: CompanionsCodingKeys.self)
            let companion = try itemCountContainer.decode(String.self, forKey: .companion)
            let isBeingDeleted = try itemCountContainer.decode(Bool.self, forKey: .isBeingDeleted)
            compArray.append((companion, isBeingDeleted))
        }
        
        compArray.forEach {
            self.companions.append(Companions(companion: $0.companion, isbeingDeleted: $0.isBeingDeleted))
        }
        
        var tripsContainer = try container.nestedUnkeyedContainer(forKey: .trips)
        
        var itemsArray = [(name: String, address: String, latitude: Double, longitude: Double, turn: Int)]()
        while !tripsContainer.isAtEnd {
            let itemCountContainer = try tripsContainer.nestedContainer(keyedBy: TripsCodingKeys.self)
            let name = try itemCountContainer.decode(String.self, forKey: .name)
            let address = try itemCountContainer.decode(String.self, forKey: .address)
            let latitude = try itemCountContainer.decode(Double.self, forKey: .latitude)
            let longitude = try itemCountContainer.decode(Double.self, forKey: .longitude)
            let turn = try itemCountContainer.decode(Int.self, forKey: .turn)
            itemsArray.append((name, address, latitude, longitude, turn))
        }
        
        itemsArray.forEach {
            self.trips.append(CurrentTrip(name: $0.name, address: $0.address, latitude: $0.latitude, longitude: $0.longitude, turn: $0.turn))
        }
    }
    
}
