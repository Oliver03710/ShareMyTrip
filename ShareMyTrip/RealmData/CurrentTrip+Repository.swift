//
//  CurrentTrip+Repository.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/19.
//

import Foundation
import MapKit

import RealmSwift

private protocol CurrentTripRepositoryType: AnyObject {
    func addItem(name: String, address: String, latitude: Double, longitude: Double, turn: Int)
    func deleteLastItem(item: CurrentTrip)
    func deleteAllItem()
    func fetchRealmData()
}

final class CurrentTripRepository: CurrentTripRepositoryType {

    private init() { }
    
    static let standard = CurrentTripRepository()
    
    // MARK: - Init
    
    let localRealm = try! Realm()
    var tasks: Results<CurrentTrip>!
    
    
    // MARK: - Helper Functions
    
    func addItem(name: String, address: String, latitude: Double, longitude: Double, turn: Int) {
        let task = CurrentTrip(name: name, address: address, latitude: latitude, longitude: longitude, turn: turn)
        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteLastItem(item: CurrentTrip) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteAllItem() {
        do {
            try localRealm.write {
                localRealm.deleteAll()
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchRealmData() {
        tasks = localRealm.objects(CurrentTrip.self)
    }
    
}
