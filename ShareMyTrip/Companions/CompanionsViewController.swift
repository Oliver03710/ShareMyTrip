//
//  CompanionsViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

final class CompanionsViewController: BaseViewController {

    // MARK: - Properties
    
    private let companionsView = CompanionsView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = companionsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        companionsView.ViewModel.checkEmpty(tableView: companionsView.tableView)
        companionsView.tableView.reloadData()
    }
    
    
    // MARK: - Selectors
    
    @objc private func addCompanions() {
        showAlertMessage(buttonText: "추가하기", alertTitle: "여행 동료 추가하기", tableView: companionsView.tableView, buttonType: .addButton, viewModel: companionsView.ViewModel)
    }
    
    @objc private func deleteAllCompanions() {
        showAlertMessage(buttonText: "삭제하기", alertTitle: "여행동료 전체 삭제", tableView: companionsView.tableView, buttonType: .deleteButton, viewModel: companionsView.ViewModel)
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
