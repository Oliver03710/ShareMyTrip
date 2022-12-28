//
//  BaseTextField.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/21.
//

import UIKit

final class BaseTextField: UITextField {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    convenience init(placeHolder: String, colorOfPlaceHolder: UIColor, borderStyle: UITextField.BorderStyle, backgroundColor: UIColor?, textColor: UIColor?) {
        self.init()
        self.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: colorOfPlaceHolder])
        self.borderStyle = borderStyle
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }

}
