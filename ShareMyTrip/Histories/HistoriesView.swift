//
//  HistoriesView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

import SnapKit

final class HistoriesView: BaseView {

    // MARK: - Init
    
    lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .insetGrouped, cellClass: HistoriesTableViewCell.self, forCellReuseIdentifier: HistoriesTableViewCell.reuseIdentifier, delegate: self)
        tv.backgroundColor = .white
        return tv
    }()
    
    private let characterImageView: CharacterImageView = {
        let iv = CharacterImageView(.zero, image: CharacterImage.tripHistoryImage.rawValue, contentMode: .scaleAspectFit)
        return iv
    }()
    
    var transitionVC: ((Int) -> Void)?
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        TripHistoryRepository.standard.fetchRealmData()
    }
    
    override func setConstraints() {
        [characterImageView, tableView].forEach { self.addSubview($0) }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
}


// MARK: - Extension: UITableViewDelegate

extension HistoriesView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let tripHistory = TripHistoryRepository.standard.fetchTripHistory()
        return tripHistory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.destinationView
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UISwipeActionsConfiguration()
        return action.trailingDeleteAction(indexPath: indexPath, viewControllerCase: .history, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        transitionVC?(indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension HistoriesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoriesTableViewCell.reuseIdentifier, for: indexPath) as? HistoriesTableViewCell else { return UITableViewCell() }
        
        let tripHistory = TripHistoryRepository.standard.fetchTripHistory()
        cell.nameLabel.text = "\(indexPath.section + 1). \(tripHistory[indexPath.section].tripName)"
        
        return cell
    }
    
}
