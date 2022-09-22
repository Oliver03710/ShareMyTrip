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
        CompanionsRepository.standard.fetchRealmData()
        tableView.isHidden = CompanionsRepository.standard.tasks.isEmpty ? true : false
    }
    
}
