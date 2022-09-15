//
//  SettingsView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

import SnapKit

class SettingsView: BaseView {

    // MARK: - Properties
    
    lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .plain, cellClass: SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        tv.bounces = false
        return tv
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        [tableView].forEach { self.addSubview($0) }
        
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }

}


// MARK: - Extension: UITableViewDelegate

extension SettingsView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.settings
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension SettingsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        
        cell.setCellComponents(index: indexPath.row)
        
        return cell
    }
    
}
