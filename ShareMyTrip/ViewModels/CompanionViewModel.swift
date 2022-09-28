//
//  CompanionViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import UIKit

import RealmSwift

final class CompanionViewModel {
    
    func checkEmpty(tableView: UITableView) {
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        tableView.isHidden = currentTrip[0].companions.isEmpty ? true : false
    }
    
}
