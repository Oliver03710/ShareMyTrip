//
//  CompanionViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import UIKit

import RealmSwift

final class CompanionViewModel {
    
    // MARK: - Properties
    
    var person: Observable<[String]> = Observable([])
        
    
    // MARK: - Helper Functions
    
    func reloadTableView(_ tableView: UITableView) {
        person.bind { _ in
            tableView.reloadData()
        }
    }
    
    func saveToRealm() {
        if let companion = person.value.last {
            CompanionsRepository.standard.addItem(companion: companion)
        }
    }
    
}
