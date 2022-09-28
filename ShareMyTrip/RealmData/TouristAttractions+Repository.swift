//
//  TouristAttractions+Repository.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/26.
//

import Foundation

import RealmSwift

private protocol TouristAttractionsRepositoryType: AnyObject {
    func addItem(name: String, address: String, introduction: String, admin: String, phoneNumber: String, latitude: Double, longitude: Double)
    func deleteSpecificItem(item: TouristAttractions)
    func fetchRealmData()
}

final class TouristAttractionsRepository: TouristAttractionsRepositoryType {

    private init() { }
    
    static let standard = TouristAttractionsRepository()
    
    // MARK: - Init
    
    let localRealm = try! Realm()
    var tasks: Results<TouristAttractions>!
    
    
    // MARK: - Helper Functions
    
    func addItem(name: String, address: String, introduction: String, admin: String, phoneNumber: String, latitude: Double, longitude: Double) {
        let task = TouristAttractions(name: name, address: address, introduction: introduction, admin: admin, phoneNumber: phoneNumber, latitude: latitude, longitude: longitude)
        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteSpecificItem(item: TouristAttractions) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchRealmData() {
        tasks = localRealm.objects(TouristAttractions.self)
    }
    
}
