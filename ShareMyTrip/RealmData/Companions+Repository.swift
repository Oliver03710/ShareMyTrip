//
//  Companions+Repository.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/21.
//

import Foundation

import RealmSwift

enum ButtonType {
    case addButton, deleteButton
}

private protocol CompanionsRepositoryType: AnyObject {
    func addItem(companion: String)
    func deleteSpecificItem(item: Companions)
    func fetchRealmData()
}

final class CompanionsRepository: CompanionsRepositoryType {

    private init() { }
    
    static let standard = CompanionsRepository()
    
    // MARK: - Init
    
    let localRealm = try! Realm()
    var tasks: Results<Companions>!
    
    
    // MARK: - Helper Functions
    
    func addItem(companion: String) {
        let task = Companions(companion: companion)
        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteSpecificItem(item: Companions) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchRealmData() {
        tasks = localRealm.objects(Companions.self)
    }
    
}
