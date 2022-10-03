//
//  CompanionsView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

import SnapKit

final class CompanionsView: BaseView {

    // MARK: - Properties
    
    lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .insetGrouped, cellClass: CompanionsTableViewCell.self, forCellReuseIdentifier: CompanionsTableViewCell.reuseIdentifier, delegate: self)
        tv.backgroundColor = .white
        return tv
    }()
    
    private let characterImageView: CharacterImageView = {
        let iv = CharacterImageView(.zero, image: CharacterImage.companionImage.rawValue, contentMode: .scaleAspectFit)
        return iv
    }()
    
    let ViewModel = CompanionViewModel()
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
    }
    
    override func setConstraints() {
        [characterImageView, tableView].forEach { self.addSubview($0) }
        
        characterImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
}


// MARK: - Extension: UITableViewDelegate

extension CompanionsView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        return currentTrip[0].companions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.settingView
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UISwipeActionsConfiguration()
        return action.trailingDeleteAction(indexPath: indexPath, viewControllerCase: .companion, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension CompanionsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanionsTableViewCell.reuseIdentifier, for: indexPath) as? CompanionsTableViewCell else { return UITableViewCell() }
        
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        cell.nameLabel.text = currentTrip[0].companions[indexPath.section].companion
        
        return cell
    }
    
}
