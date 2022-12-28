//
//  TripHistory+Repository.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/19.
//

import UIKit

import RealmSwift

private protocol TripHistoryRepositoryType: AnyObject {
    func addItem(tripName: String, trips: [CurrentTrip], companions: [Companions])
//    func updateItem(text: String)
    func updateItem(trip: CurrentTrip)
    func updateTripName(text: String)
    func finishTrip()
    func deleteDestinationItem(item: CurrentTrip)
    func deleteItem(item: TripHistory)
    func fetchRealmData()
    func fetchTrips(_ state: TripHistoryRepository.TripStates) -> Results<TripHistory>
}

final class TripHistoryRepository: TripHistoryRepositoryType {

    // MARK: - enum
    
    enum TripStates {
        case current, history, total
    }
    
    
    // MARK: - Properties
    
    static let standard = TripHistoryRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<TripHistory>!
    var companionsTasks: Results<Companions>!
    
    
    // MARK: - Init
    
    private init() { }
    
    
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
    
    func updateItem(text: String, isContained: Companions? = nil) {
        do {
            try localRealm.write {
                if isContained == nil {
                    let companion = Companions(companion: text)
                    fetchTrips(.current).first?.companions.append(companion)
                } else {
                    if let item = isContained {
                        fetchTrips(.current)[0].companions.append(item)
                    }
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func willDeleteItem(item: Companions) {
        do {
            try localRealm.write {
                item.isbeingDeleted = true
            }
        } catch let error {
            print(error)
        }
    }

    
    func updateItem(trip: CurrentTrip) {
        do {
            try localRealm.write {
                fetchTrips(.current).first?.trips.append(trip)
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateTripName(text: String) {
        do {
            try localRealm.write {
                fetchTrips(.current).first?.tripName = text
            }
        } catch let error {
            print(error)
        }
    }
    
    func finishTrip() {
        do {
            try localRealm.write {
                fetchTrips(.current).first?.isTraveling = false
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
    
    func deleteAllItem() {
        do {
            try localRealm.write {
                localRealm.deleteAll()
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteCompanionItem(item: Companions, isContained: Companions? = nil) {
        do {
            try localRealm.write {
                if isContained == nil {
                    localRealm.delete(item)
                } else {
                    if let index = fetchTrips(.current)[0].companions.firstIndex(of: item) {
                        fetchTrips(.current)[0].companions.remove(at: index)
                    }
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteAllCompanionItem() {
        do {
            try localRealm.write {
                var compareData = Array<Companions>()
                var hideData = Array<Companions>()
                var trashData = Array<Companions>()
                
                fetchTrips(.current).forEach { data in
                    data.companions.forEach { compareData.append($0) }
                }
                
                fetchTrips(.history).where({ $0.isTraveling == false }).forEach { trips in
                    compareData.forEach { trips.companions.contains($0) ? hideData.append($0) : trashData.append($0) }
                }
                
                trashData.forEach { $0.isbeingDeleted = true }
                hideData.forEach { item in
                    if let index = fetchTrips(.current)[0].companions.firstIndex(of: item) {
                        fetchTrips(.current)[0].companions.remove(at: index)
                    }
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchRealmData() {
        tasks = localRealm.objects(TripHistory.self)
    }
    
    func fetchCompanionsRealmData() {
        companionsTasks = localRealm.objects(Companions.self)
    }
        
    func fetchTrips(_ state: TripHistoryRepository.TripStates) -> Results<TripHistory> {
        switch state {
        case .current:
            tasks = localRealm.objects(TripHistory.self)
            return tasks.where { $0.isTraveling == true }
        case .history:
            tasks = localRealm.objects(TripHistory.self)
            return tasks.where { $0.isTraveling == false }
        case .total:
            tasks = localRealm.objects(TripHistory.self)
            return tasks
        }
    }
    
    func saveEncodedDataToDocument(vc: UIViewController) throws {
        fetchRealmData()
        guard let task = tasks else { return }
        let encodedData = try encodeData(task)
        
        print(encodedData)
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw DocumentError.fetchDirectoryPathError
        }
        
        let jsonDataPath = documentDirectory.appendingPathComponent("encodedData.json")
        
        try encodedData.write(to: jsonDataPath)
    }
    
    func encodeData(_ data: Results<TripHistory>) throws -> Data {
        do {
            let encoder = JSONEncoder()
            
            encoder.dateEncodingStrategy = .iso8601
            
            let encodedData: Data = try encoder.encode(data)
            
            return encodedData
        }
        catch {
            throw CodableError.jsonEncodeError
        }
    }
    
    func decodeData() throws -> Data {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw DocumentError.fetchJsonDataError
        }
        
//        print(path)
        
        let dataPath = documentDirectory.appendingPathComponent("encodedData.json")
        
//        print(dataPath)
        do {
            return try Data(contentsOf: dataPath)
        } catch {
            throw DocumentError.fetchJsonDataError
        }
    }
    
    func restoreRealmForBackupFile() throws {
        let jsonData = try decodeData()
        
        guard let decodedData = try decodeTrip(jsonData) else { return }
        print(decodedData)
        try localRealm.write {
            localRealm.deleteAll()
            localRealm.add(decodedData)
        }
    }
    
    func decodeTrip(_ tripData: Data) throws -> [TripHistory]? {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedData: [TripHistory] = try decoder.decode([TripHistory].self, from: tripData)
            print(decodedData)
            return decodedData
        } catch {
            throw CodableError.jsonDecodeError
        }
    }
    
}
