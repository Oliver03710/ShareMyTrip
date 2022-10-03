//
//  DestinationsView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/21.
//

import UIKit

import SnapKit
import PanModal

final class DestinationsView: BaseView {
    
    // MARK: - Init
    
    lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .insetGrouped, cellClass: DestinationsTableViewCell.self, forCellReuseIdentifier: DestinationsTableViewCell.reuseIdentifier, delegate: self)
        tv.backgroundColor = .white
        return tv
    }()
    
    private let characterImageView: CharacterImageView = {
        let iv = CharacterImageView(.zero, image: CharacterImage.destinationImage.rawValue, contentMode: .scaleAspectFit)
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

extension DestinationsView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        return currentTrip[0].trips.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.destinationView
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

extension DestinationsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DestinationsTableViewCell.reuseIdentifier, for: indexPath) as? DestinationsTableViewCell else { return UITableViewCell() }
        
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        cell.nameLabel.text = "\(indexPath.section + 1). \(currentTrip[0].trips[indexPath.section].name)"
        cell.addressLabel.text = "\(currentTrip[0].trips[indexPath.section].address)"
        
        return cell
    }
    
}
