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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sharingListView.ViewModel.checkEmpty(tableView: sharingListView.tableView)
        sharingListView.tableView.reloadData()
    }
    
    
    // MARK: - Selectors
    
    @objc private func addCompanions() {
        showAlertMessage(buttonText: "추가하기", alertTitle: "여행 동료 추가하기", tableView: sharingListView.tableView, buttonType: .addButton, viewModel: sharingListView.ViewModel)
    }
    
    @objc private func deleteAllCompanions() {
        showAlertMessage(buttonText: "삭제하기", alertTitle: "여행동료 전체 삭제", tableView: sharingListView.tableView, buttonType: .deleteButton, viewModel: sharingListView.ViewModel)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        setNaviButtons()
    }
    
    private func setNaviButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.plus"), style: .plain, target: self, action: #selector(addCompanions))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.minus"), style: .plain, target: self, action: #selector(deleteAllCompanions))
        navigationController?.navigationBar.tintColor = .systemBrown
    }

}
