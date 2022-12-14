//
//  HistoriesViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

import PanModal

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
        historiesView.viewModel.checkEmpty(tableView: historiesView.tableView)
        historiesView.tableView.reloadData()
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        historiesView.transitionVC = { index in
            let vc = DetailHistoriesViewController()
            vc.detailHistoriesView.index = index
            self.presentPanModal(vc)
        }
    }
    
}
