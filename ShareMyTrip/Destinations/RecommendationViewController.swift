//
//  RecommendationViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/27.
//

import UIKit

import PanModal

final class RecommendationViewController: BaseViewController {

    // MARK: - Properties

    let recommendationView = RecommendationView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = recommendationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recommendationView.tableView.isHidden = recommendationView.viewModel.touristAttractionsAnno.value.isEmpty ? true : false
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        recommendationView.viewModel.regionContainsAnno(index: recommendationView.index)
    }

}


// MARK: - Extension: PanModalPresentable

extension RecommendationViewController: PanModalPresentable {

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
