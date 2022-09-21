//
//  BaseLabel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import UIKit

final class BaseLabel: UILabel {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() {
        self.textColor = .label
    }
    
    convenience init(boldStyle: UIFont.Weight, fontSize: CGFloat, text: String?) {
        self.init()
        self.font = .systemFont(ofSize: fontSize, weight: boldStyle)
        self.text = text
    }
    
    convenience init(boldStyle: UIFont.Weight, fontSize: CGFloat, text: String?, textAlignment: NSTextAlignment) {
        self.init()
        self.font = .systemFont(ofSize: fontSize, weight: boldStyle)
        self.text = text
        self.textAlignment = textAlignment
    }

}
