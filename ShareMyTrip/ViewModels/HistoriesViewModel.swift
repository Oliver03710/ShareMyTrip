//
//  HistoriesViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import UIKit

final class HistoriesViewModel {
  
    // MARK: - Helper Functions
    
    func checkEmpty(tableView: UITableView) {
        let tripHistory = TripHistoryRepository.standard.fetchTripHistory()
        tableView.isHidden = tripHistory.isEmpty ? true : false
    }
    
}
