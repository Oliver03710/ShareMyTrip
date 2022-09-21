//
//  HistoriesView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

import PanModal
import SnapKit

final class HistoriesView: BaseView {

    // MARK: - Init
    
    private lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .plain, cellClass: HistoriesTableViewCell.self, forCellReuseIdentifier: HistoriesTableViewCell.reuseIdentifier, delegate: self)
        return tv
    }()
    
    private let viewModel = HistoriesViewModel()
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        let testArr = ["강원도 춘천", "경기도 가평", "경상도 경주", "부산"]
        viewModel.destinations.value.append(contentsOf: testArr)
    }
    
    override func setConstraints() {
        [tableView].forEach { self.addSubview($0) }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
}


// MARK: - Extension: UITableViewDelegate

extension HistoriesView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.destinationView
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension HistoriesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.destinations.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoriesTableViewCell.reuseIdentifier, for: indexPath) as? HistoriesTableViewCell else { return UITableViewCell() }
        
        cell.nameLabel.text = "\(indexPath.row + 1). \(viewModel.destinations.value[indexPath.row])"
        
        return cell
    }
    
}
