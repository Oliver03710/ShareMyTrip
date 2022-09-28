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
        let tv = BaseTableView(frame: .zero, style: .plain, cellClass: HistoriesTableViewCell.self, forCellReuseIdentifier: HistoriesTableViewCell.reuseIdentifier, delegate: self)
        return tv
    }()
    
    private let characterImageView: CharacterImageView = {
        let iv = CharacterImageView(.zero, image: CharacterImage.smile.rawValue, contentMode: .scaleAspectFit)
        iv.alpha = 0.5
        return iv
    }()
    
    private let bubbleLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .heavy, fontSize: 20, text: "여행가자곰과 더 여행해보세요!")
        label.textAlignment = .center
        label.textColor = .gray
        return label
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
        [characterImageView, bubbleLabel, tableView].forEach { self.addSubview($0) }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).multipliedBy(1)
            make.height.width.equalTo(200)
        }
        
        bubbleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).multipliedBy(0.7)
            make.height.equalTo(20)
            make.width.equalTo(self.snp.width)
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
        let action = UISwipeActionsConfiguration()
        return action.trailingDeleteAction(indexPath: indexPath, viewControllerCase: .history, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        transitionVC?(indexPath.row)
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension HistoriesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tripHistory = TripHistoryRepository.standard.fetchTripHistory()
        return tripHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoriesTableViewCell.reuseIdentifier, for: indexPath) as? HistoriesTableViewCell else { return UITableViewCell() }
        
        let tripHistory = TripHistoryRepository.standard.fetchTripHistory()
        cell.nameLabel.text = "\(indexPath.row + 1). \(tripHistory[indexPath.row].tripName)"
        
        return cell
    }
    
}
