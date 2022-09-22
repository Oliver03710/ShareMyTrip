//
//  HistoriesViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

final class HistoriesViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let historiesView = HistoriesView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = historiesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TripHistoryRepository.standard.fetchRealmData()
        historiesView.tableView.reloadData()
        historiesView.tableView.isHidden = TripHistoryRepository.standard.tasks.isEmpty ? true : false
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        
    }
    
}
