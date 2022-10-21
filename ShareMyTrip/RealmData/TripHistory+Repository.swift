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
    func deleteDestinationItem(item: CurrentTrip)
    func deleteItem(item: TripHistory)
    func fetchRealmData()
    func fetchCurrentTrip() -> Results<TripHistory>
    func fetchTripHistory() -> Results<TripHistory>
}

final class TripHistoryRepository: TripHistoryRepositoryType {

    // MARK: - Properties
    
    static let standard = TripHistoryRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<TripHistory>!
    
    
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
    
    func deleteAllItem() {
        do {
            try localRealm.write {
                localRealm.deleteAll()
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
