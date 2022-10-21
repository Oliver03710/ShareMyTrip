//
//  Companions.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/21.
//

import Foundation

import RealmSwift

final class Companions: Object, Codable {
    
    private override init() { }
    
    @Persisted var companion: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(companion: String) {
        self.init()
        self.companion = companion
    }
    
    private enum CodingKeys: CodingKey {
        case companion
        case objectId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.companion, forKey: .companion)
        try container.encode(self.objectId, forKey: .objectId)
    }
    
}
