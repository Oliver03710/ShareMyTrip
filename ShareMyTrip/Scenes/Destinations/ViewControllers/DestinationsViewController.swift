//
//  DestinationsViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/21.
//

import UIKit

import PanModal

final class DestinationsViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let destinationsView = DestinationsView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = destinationsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let currentTrip = TripHistoryRepository.standard.fetchTrips(.current)
        destinationsView.tableView.isHidden = currentTrip[0].trips.isEmpty ? true : false
        destinationsView.tableView.reloadData()
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        destinationsView.transitionVC = { index in
            let vc = RecommendationViewController()
            vc.index = index
            self.presentPanModal(vc)
        }
    }
    
}
