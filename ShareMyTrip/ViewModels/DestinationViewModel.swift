//
//  DestinationViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/21.
//

import UIKit

final class DestinationViewModel {
    
    // MARK: - Properties
    
    var destinations: Observable<[String]> = Observable([])
        
    
    // MARK: - Helper Functions
    
    func reloadTableView(_ tableView: UITableView) {
        destinations.bind { _ in
            tableView.reloadData()
        }
    }
    
}
