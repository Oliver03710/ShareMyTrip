//
//  CurrentTrip+Realm.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/19.
//

import Foundation

import RealmSwift

final class CurrentTrip: Object {
    @Persisted var name: String
    @Persisted var address: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var turn: Int
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(name: String, address: String, latitude: Double, longitude: Double, turn: Int) {
        self.init()
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.turn = turn
    }
    
}
