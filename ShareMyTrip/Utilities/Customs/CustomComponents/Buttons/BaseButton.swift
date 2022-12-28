//
//  BaseButton.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import UIKit

final class BaseButton: UIButton {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    convenience init(backgroundColor: UIColor, titleOrImage: String, hasTitle: Bool, componentColor: UIColor?, addTarget: UIViewController, action: Selector) {
        self.init()
        self.backgroundColor = backgroundColor
        
        if hasTitle {
            self.setTitle(titleOrImage, for: .normal)
            self.setTitleColor(componentColor, for: .normal)
        } else {
            self.setImage(UIImage(systemName: titleOrImage), for: .normal)
            self.tintColor = componentColor
        }
        
        self.addTarget(addTarget, action: action, for: .touchUpInside)
    }
    
    convenience init(buttonTitle: String?, textColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat) {
        self.init()
        self.setTitle(buttonTitle, for: .normal)
        self.titleLabel?.textColor = textColor
        self.backgroundColor = backgroundColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
    }

}
