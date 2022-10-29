//
//  CompanionsWithCVViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/25.
//

import UIKit

final class CompanionsWithCVViewController: BaseViewController {

    // MARK: - Properties
    
    private let companionsView = CompanionsWithCVView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = companionsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Selectors
    
    @objc private func addCompanions() {
        showAlertMessage(buttonText: "추가하기", alertTitle: "여행 동료 추가하기", collectionView: companionsView.collectionView, buttonType: .addButton, viewModel: companionsView.viewModel)
    }
    
    @objc private func deleteAllCompanions() {
        showAlertMessage(buttonText: "삭제하기", alertTitle: "여행동료 전체 삭제", collectionView: companionsView.collectionView, buttonType: .deleteButton, viewModel: companionsView.viewModel)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        setNaviButtons()
    }
    
    private func setNaviButtons() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.plus"), style: .plain, target: self, action: #selector(addCompanions))
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.minus"), style: .plain, target: self, action: #selector(deleteAllCompanions))
        navigationItem.rightBarButtonItems = [addButton, deleteButton]
    }

}
