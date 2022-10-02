//
//  DetailHistoriesViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/23.
//

import UIKit

import PanModal

final class DetailHistoriesViewController: BaseViewController {

    // MARK: - Properties

    let detailHistoriesView = DetailHistoriesView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = detailHistoriesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TripHistoryRepository.standard.fetchRealmData()
        detailHistoriesView.tableView.reloadData()
        detailHistoriesView.tableView.isHidden = TripHistoryRepository.standard.tasks[detailHistoriesView.index].companions.isEmpty ? true : false
    }

}


// MARK: - Extension: PanModalPresentable

extension DetailHistoriesViewController: PanModalPresentable {

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
