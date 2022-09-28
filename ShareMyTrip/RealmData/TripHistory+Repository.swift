//
//  TripHistory+Repository.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/19.
//

import Foundation

import RealmSwift

private protocol TripHistoryRepositoryType: AnyObject {
    func addItem(tripName: String, trips: [CurrentTrip], companions: [Companions])
    func deleteDestinationItem(item: CurrentTrip)
    func deleteItem(item: TripHistory)
    func fetchRealmData()
    func fetchCurrentTrip() -> Results<TripHistory>
    func fetchTripHistory() -> Results<TripHistory>
}

final class TripHistoryRepository: TripHistoryRepositoryType {

    private init() { }
    
    static let standard = TripHistoryRepository()
    
    // MARK: - Init
    
    let localRealm = try! Realm()
    var tasks: Results<TripHistory>!
    
    
    // MARK: - Helper Functions
    
    func addItem(tripName: String, trips: [CurrentTrip], companions: [Companions]) {
        let task = TripHistory(tripName: tripName, trips: trips, companions: companions)
        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateItem(text: String) {
        let currentTrip = fetchCurrentTrip()
        do {
            try localRealm.write {
                let companion = Companions(companion: text)
                currentTrip.first?.companions.append(companion)
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateItem(trip: CurrentTrip) {
        let currentTrip = fetchCurrentTrip()
        do {
            try localRealm.write {
                currentTrip.first?.trips.append(trip)
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateTripName(text: String) {
        let currentTrip = fetchCurrentTrip()
        do {
            try localRealm.write {
                currentTrip[0].tripName = text
            }
        } catch let error {
            print(error)
        }
    }
    
    func finishTrip() {
        let currentTrip = fetchCurrentTrip()
        do {
            try localRealm.write {
                currentTrip.first?.isTraveling = false
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteDestinationItem(item: CurrentTrip) {
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
    
    func deleteCompanionItem(item: Companions) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteAllCompanionItem() {
        let currentTrip = fetchCurrentTrip()
        do {
            try localRealm.write {
                currentTrip[0].companions.removeAll()
            }
        } catch let error {
            print(error)
        }
    }

    
    func fetchRealmData() {
        tasks = localRealm.objects(TripHistory.self)
    }
    
    func fetchCurrentTrip() -> Results<TripHistory> {
        tasks = localRealm.objects(TripHistory.self)
        return tasks.where { $0.isTraveling == true }
    }
    
    func fetchTripHistory() -> Results<TripHistory> {
        tasks = localRealm.objects(TripHistory.self)
        return tasks.where { $0.isTraveling == false }
    }
    
}
