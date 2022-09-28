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
        let tv = BaseTableView(frame: .zero, style: .plain, cellClass: CompanionsTableViewCell.self, forCellReuseIdentifier: CompanionsTableViewCell.reuseIdentifier, delegate: self)
        return tv
    }()
    
    private let characterImageView: CharacterImageView = {
        let iv = CharacterImageView(.zero, image: CharacterImage.smile.rawValue, contentMode: .scaleAspectFit)
        iv.alpha = 0.5
        return iv
    }()
    
    private let bubbleLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .heavy, fontSize: 20, text: "여행에 함께 갈 친구를 추가해보세요.")
        label.textAlignment = .center
        label.textColor = .gray
        return label
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
        [characterImageView, bubbleLabel, tableView].forEach { self.addSubview($0) }
        
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
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
}


// MARK: - Extension: UITableViewDelegate

extension CompanionsView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.settingView
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UISwipeActionsConfiguration()
        return action.trailingDeleteAction(indexPath: indexPath, viewControllerCase: .companion, tableView: tableView)
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension CompanionsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        return currentTrip[0].companions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanionsTableViewCell.reuseIdentifier, for: indexPath) as? CompanionsTableViewCell else { return UITableViewCell() }
        
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        cell.nameLabel.text = currentTrip[0].companions[indexPath.row].companion
        
        return cell
    }
    
}
