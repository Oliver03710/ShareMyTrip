//
//  CompanionsCollectionViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/25.
//

import UIKit

import SnapKit

final class CompanionsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let nameLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 15, text: nil)
        label.textColor = #colorLiteral(red: 0.3490196078, green: 0.2431372549, blue: 0.1647058824, alpha: 1)
        return label
    }()
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1, green: 0.9450980392, blue: 0.8431372549, alpha: 1)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    private func setConstraints() {
        self.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
    }
}
