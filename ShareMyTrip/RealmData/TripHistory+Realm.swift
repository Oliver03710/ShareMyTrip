//
//  TripHistory+Realm.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/19.
//

import Foundation

import RealmSwift

class TripHistory: Object {
    @Persisted var tripName: String
    @Persisted var destinations = List<String>()
    @Persisted var companions = List<String>()
    @Persisted var addresses = List<String>()
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(tripName: String, desnitations: [String], companions: [String], addresses: [String]) {
        self.init()
        self.tripName = tripName
        self.destinations.append(objectsIn: desnitations)
        self.companions.append(objectsIn: companions)
        self.addresses.append(objectsIn: addresses)
    }
    
}
