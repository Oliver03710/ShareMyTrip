//
//  CustomStackView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/22.
//

import UIKit

final class CustomStackView: UIStackView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    convenience init(arrangedSubviews views: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) {
        self.init()
        views.forEach { self.addArrangedSubview($0) }
        self.axis = axis
        self.spacing = UIScreen.main.bounds.width / spacing
        self.distribution = distribution

    }

}
