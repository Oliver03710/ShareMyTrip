//
//  ShowCompanionViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/23.
//

import UIKit

import PanModal

final class ShowCompanionViewController: BaseViewController {

    // MARK: - Properties

    let showCompanionView = ShowCompanionView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = showCompanionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TripHistoryRepository.standard.fetchRealmData()
        showCompanionView.tableView.reloadData()
        showCompanionView.tableView.isHidden = TripHistoryRepository.standard.tasks[showCompanionView.index].companions.isEmpty ? true : false
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        
    }

}


// MARK: - Extension: PanModalPresentable

extension ShowCompanionViewController: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(UIScreen.main.bounds.height / 100)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
}
