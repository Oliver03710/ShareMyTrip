//
//  TripHistory+Repository.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/19.
//

import Foundation

import RealmSwift

private protocol TripHistoryRepositoryType: AnyObject {
    func addItem(tripName: String, desnitations: [String], companions: [String], addresses: [String])
    func deleteSpecificItem(item: TripHistory)
    func deleteItem(item: TripHistory)
    func fetchRealmData()
}

final class TripHistoryRepository: TripHistoryRepositoryType {

    private init() { }
    
    static let standard = TripHistoryRepository()
    
    // MARK: - Init
    
    let localRealm = try! Realm()
    var tasks: Results<TripHistory>!
    
    
    // MARK: - Helper Functions
    
    func addItem(tripName: String, desnitations: [String], companions: [String], addresses: [String]) {
        let task = TripHistory(tripName: tripName, desnitations: desnitations, companions: companions, addresses: addresses)
        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteSpecificItem(item: TripHistory) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteItem(item: TripHistory) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchRealmData() {
        tasks = localRealm.objects(TripHistory.self)
    }
    
}
