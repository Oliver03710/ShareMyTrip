//
//  SharingListViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

class SharingListViewController: BaseViewController {

    // MARK: - Properties
    
    let sharingListView = SharingListView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = sharingListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Selectors
    
    @objc func addCompanions() {
        addCompanionAlertMessage(buttonText: "추가하기", alertTitle: "여행 동료 추가하기", target: sharingListView.companionViewModel.person)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        setNaviButtons()
    }
    
    func setNaviButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCompanions))
    }

}
