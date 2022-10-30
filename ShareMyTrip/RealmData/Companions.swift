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
    @Persisted var isbeingDeleted: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(companion: String, isbeingDeleted: Bool = false) {
        self.init()
        self.companion = companion
        self.isbeingDeleted = isbeingDeleted
    }
    
    private enum CodingKeys: CodingKey {
        case companion
        case isbeingDeleted
        case objectId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.companion, forKey: .companion)
        try container.encode(self.isbeingDeleted, forKey: .isbeingDeleted)
        try container.encode(self.objectId, forKey: .objectId)
    }
    
}
