//
//  DestinationsView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/21.
//

import UIKit

import SnapKit

final class DestinationsView: BaseView {
    
    // MARK: - Init
    
    lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .plain, cellClass: DestinationsTableViewCell.self, forCellReuseIdentifier: DestinationsTableViewCell.reuseIdentifier, delegate: self)
        return tv
    }()
    
    private let characterImageView: CharacterImageView = {
        let iv = CharacterImageView(.zero, image: CharacterImage.smile.rawValue, contentMode: .scaleAspectFit)
        iv.alpha = 0.5
        return iv
    }()
    
    private let bubbleLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .heavy, fontSize: 20, text: "지도 탭에서 목적지를 추가해보세요!")
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
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

extension DestinationsView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.destinationView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension DestinationsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentTripRepository.standard.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DestinationsTableViewCell.reuseIdentifier, for: indexPath) as? DestinationsTableViewCell else { return UITableViewCell() }
        
        cell.nameLabel.text = "\(indexPath.row + 1). \(CurrentTripRepository.standard.tasks[indexPath.row].name)"
        
        return cell
    }
    
}
