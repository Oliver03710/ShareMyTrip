//
//  CurrentTrip+Repository.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/19.
//

//import Foundation
//import MapKit
//
//import RealmSwift

//private protocol CurrentTripRepositoryType: AnyObject {
//    func addItem(name: String, address: String, latitude: Double, longitude: Double, turn: Int)
//    func deleteLastItem(item: CurrentTrip)
//    func fetchRealmData()
//}

//final class CurrentTripRepository {
//
//    private init() { }
//
//    static let standard = CurrentTripRepository()
//
//    // MARK: - Init
//
//    let localRealm = try! Realm()
//    var tasks: Results<CurrentTrip>!
    
    
    // MARK: - Helper Functions
    
//    func savedatatodocument() throws {
//        // 가드 렛
//        let encodedData = try saveEncode(data: tasks!)
//        
//        try documentDirectoryPath()
//    }
//    
//    func documentDirectoryPath() -> URL? {
//        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
//        return documentDirectory
//    }
//    
//    func saveJasonDocument(_ data: Data) {
//        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let fileURL = documentDirectory.appendingPathComponent("gom.json")
//        
//        do {
//            try data.write(to: fileURL)
//        } catch let error {
//            print("file save error", error)
//        }
//    }
    
//    func saveEncode(_ data: Results<CurrentTrip>) throws -> Data {
//        do {
//            let encoder = JSONEncoder()
//            encoder.dataEncodingStrategy = .iso8601
//
//            let encodedData: Data = try encoder.encode(data)
//
//            return encodedData
//        } catch {
//            print(error)
//        }
//    }
    
//    func jsontoData() throws -> Data {
//        guard let path = documentDirectoryPath() else { throw
//            error
//        }
//
//        let dataPath = path.appendingPathComponent("gom.json")
//
//        do {
//            return try Data(contentsOf: dataPath)
//        } catch {
//            throw error
//        }
//    }
    
//    func decodeData(_ tripData: Data) throws -> [CurrentTrip]? {
//        do {
//            let decoder = JSONDecoder()
//            decoder.dataDecodingStrategy = .formatted()
//            let decodedData: [CurrentTrip] = try decoder.decode([CurrentTrip].self, from: tripData)
//            return decodedData
//        } catch {
//            print(error)
//        }
//    }

    
    
    
    
//    func addItem(name: String, address: String, latitude: Double, longitude: Double, turn: Int) {
//        let task = CurrentTrip(name: name, address: address, latitude: latitude, longitude: longitude, turn: turn)
//        do {
//            try localRealm.write {
//                localRealm.add(task)
//            }
//        } catch let error {
//            print(error)
//        }
//    }
//
//    func deleteLastItem(item: CurrentTrip) {
//        do {
//            try localRealm.write {
//                localRealm.delete(item)
//            }
//        } catch let error {
//            print(error)
//        }
//    }
    
//    func fetchRealmData() {
//        tasks = localRealm.objects(CurrentTrip.self)
//    }
    
//}
