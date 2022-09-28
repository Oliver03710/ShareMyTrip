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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.tripName, forKey: .tripName)
        try container.encode(self.isTraveling, forKey: .isTraveling)
        let tripArray = Array(self.trips)
        try container.encode(tripArray, forKey: .trips)
        let companionArray = Array(self.companions)
        try container.encode(companionArray, forKey: .companions)
    }
    
    
}
