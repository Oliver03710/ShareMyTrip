//
//  SharingListViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

final class SharingListViewController: BaseViewController {

    // MARK: - Properties
    
    private let sharingListView = SharingListView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = sharingListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Selectors
    
    @objc private func addCompanions() {
        showAlertMessage(buttonText: "추가하기", alertTitle: "여행 동료 추가하기", target: sharingListView.companionViewModel.person)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        setNaviButtons()
    }
    
    private func setNaviButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.plus"), style: .plain, target: self, action: #selector(addCompanions))
        navigationController?.navigationBar.tintColor = .systemBrown
    }

}
