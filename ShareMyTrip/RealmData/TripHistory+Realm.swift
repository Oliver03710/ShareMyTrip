//
//  TripHistory+Realm.swift
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
        case companion
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.tripName, forKey: .tripName)
        try container.encode(self.isTraveling, forKey: .isTraveling)
        
        var tripContainer = encoder.container(keyedBy: TripsCodingKeys.self)
        for value in trips {
            try tripContainer.encode(value.name, forKey: .name)
            try tripContainer.encode(value.address, forKey: .address)
            try tripContainer.encode(value.latitude, forKey: .latitude)
            try tripContainer.encode(value.longitude, forKey: .longitude)
            try tripContainer.encode(value.turn, forKey: .turn)
        }
        
        var companionContainer = encoder.container(keyedBy: CompanionsCodingKeys.self)
        for value in companions {
            try companionContainer.encode(value.companion, forKey: .companion)
        }
        
        
        
        
//        let tripArray = Array(trips)
//        try container.encode(tripArray, forKey: .trips)

//        for element in trips {
//            let subencoder = container.superEncoder()
//            try (element as Codable).encode(to: subencoder)
//        }

//        for element in companions {
//            let subencoder = container.superEncoder()
//            try (element as Codable).encode(to: subencoder)
//        }
        
//        let companionArray = Array(self.companions)
//        try container.encode(companionArray, forKey: .companions)
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._tripName = try container.decode(Persisted<String>.self, forKey: .tripName)
        self._isTraveling = try container.decode(Persisted<Bool>.self, forKey: .isTraveling)
        
        let companionContainer = try decoder.container(keyedBy: CompanionsCodingKeys.self)
        let a = try companionContainer.decode(String.self, forKey: .companion)
//        var name = try container.decode(String.self, forKey: .companions)
//        companions.append(Companions(companion: name))
//
//        let comp = try container.decodeIfPresent([Companions].self, forKey: .companions) ?? [Companions()]
//                companions.append(objectsIn: comp)
        
//        self._trips = try container.decode(Persisted<List<CurrentTrip>>.self, forKey: .trips)
//        self._companions = try container.decode(Persisted<List<Companions>>.self, forKey: .companions)

//        let companionContainer = try decoder.container(keyedBy: CompanionsCodingKeys.self)
//        let name = try companionContainer.decode(String.self, forKey: .companion)
//        self.companions.append(Companions(companion: name))
        
        
//        let tripContainer = try decoder.container(keyedBy: TripsCodingKeys.self)
        
        
//        for value in self.trips {
//            value.name = try tripContainer.decode(String.self, forKey: .name)
//            value.address = try tripContainer.decode(String.self, forKey: .address)
//            value.turn = try tripContainer.decode(Int.self, forKey: .turn)
//            value.latitude = try tripContainer.decode(Double.self, forKey: .latitude)
//            value.longitude = try tripContainer.decode(Double.self, forKey: .longitude)
//            print(value)
//        }
//        self.trips.append(<#T##object: CurrentTrip##CurrentTrip#>)
        
//        let companionContainer = try decoder.container(keyedBy: CompanionsCodingKeys.self)
//
//        for value in self.companions {
//            value.companion = try companionContainer.decode(String.self, forKey: .companion)
//        }
        
//        var companionContainer = try decoder.unkeyedContainer()
//        while !companionContainer.isAtEnd {
//            let element = try companionContainer.decode(String.self)
//            companions.append(element)
//            print(element)
//            companions.forEach {
//                $0.companion = element
//            }
//        }
        
//        var companionContainer = try container.nestedUnkeyedContainer(forKey: .companions)
        
//        var itemsArray = [String]()
//        while !companionContainer.isAtEnd {
//            let itemCountContainer = try companionContainer.nestedContainer(keyedBy: CompanionsCodingKeys.self)
//            itemsArray.append(try itemCountContainer.decode(String.self, forKey: .companion))
//        }
//
//        guard let item = itemsArray.first else {
//            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: companionContainer.codingPath + [CompanionsCodingKeys.companion], debugDescription: "items cannot be empty"))
//        }
//
//        for value in self.companions {
//            value.companion = item
//        }
        
//        self._trips = try tripContainer.decode(Persisted<List<CurrentTrip>>.self, forKey: .name)
//
//        self._companions = try container.decode(Persisted<List<Companions>>.self, forKey: .companions)
    }
    
}
