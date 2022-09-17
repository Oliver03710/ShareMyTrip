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
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        
    }
    
}
