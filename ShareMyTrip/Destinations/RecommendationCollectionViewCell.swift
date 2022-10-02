//
//  RecommendationCollectionViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/27.
//

import UIKit

import SnapKit

final class RecommendationCollectionViewCell: CustomCollectionViewCell {

    // MARK: - Properties
    
    private let nameLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .medium, fontSize: 16, text: nil, textAlignment: .center)
        return label
    }()
    
    private let addressLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .light, fontSize: 13, text: nil, textAlignment: .center)
        label.numberOfLines = 0
        return label
    }()
    
    private let adminLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 15, text: nil, textAlignment: .center)
        return label
    }()
    
    private let phoneNumLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 15, text: nil, textAlignment: .center)
        return label
    }()
    
    private let introductionLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .light, fontSize: 13, text: nil)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func setConstraints() {
        
        [nameLabel, addressLabel, adminLabel, phoneNumLabel, introductionLabel].forEach { addSubview($0) }
        
        nameLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.top.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(17)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.height.equalTo(14)
            
        }
        
        adminLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(addressLabel.snp.bottom).offset(16)
            make.height.equalTo(16)
        }
        
        phoneNumLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(adminLabel.snp.bottom).offset(16)
            make.height.equalTo(16)
        }
        
        introductionLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(phoneNumLabel.snp.bottom).offset(16)
            make.bottom.greaterThanOrEqualTo(self.safeAreaLayoutGuide)
        }
        
    }
    
    func setLabels(nameText: String?, addressText: String?, introductionText: String?, adminText: String?, phoneNumText: String?) {
        nameLabel.text = nameText
        addressLabel.text = addressText
        introductionLabel.text = introductionText
        adminLabel.text = adminText
        phoneNumLabel.text = phoneNumText
    }

}

