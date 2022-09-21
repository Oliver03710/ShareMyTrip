//
//  DestinationsViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/21.
//

import UIKit

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
        CurrentTripRepository.standard.fetchRealmData()
        destinationsView.tableView.reloadData()
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        
    }
    
}
