//
//  SharingListView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

import SnapKit

final class SharingListView: BaseView {

    // MARK: - Init
    
    private lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .plain, cellClass: SharingListTableViewCell.self, forCellReuseIdentifier: SharingListTableViewCell.reuseIdentifier, delegate: self)
        return tv
    }()
    
    let companionViewModel = CompanionViewModel()
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        reloadTableView()
    }
    
    override func setConstraints() {
        [tableView].forEach { self.addSubview($0) }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
    private func reloadTableView() {
        companionViewModel.person.bind { _ in
            self.tableView.reloadData()
        }
    }
    
}


// MARK: - Extension: UITableViewDelegate

extension SharingListView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.settings
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension SharingListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companionViewModel.person.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SharingListTableViewCell.reuseIdentifier, for: indexPath) as? SharingListTableViewCell else { return UITableViewCell() }
        
        cell.nameLabel.text = companionViewModel.person.value[indexPath.row]
        
        return cell
    }
    
}
