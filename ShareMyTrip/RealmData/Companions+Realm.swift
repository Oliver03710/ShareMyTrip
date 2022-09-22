//
//  Companions+Realm.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/21.
//

import Foundation

import RealmSwift

final class Companions: Object {
    @Persisted var companion: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(companion: String) {
        self.init()
        self.companion = companion
    }
    
}
