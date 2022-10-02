//
//  CustomCollectionViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/30.
//

import UIKit

import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() { }
    func setConstraints() { }
    

    
    
}
