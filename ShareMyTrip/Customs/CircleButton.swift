//
//  CircleButton.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/22.
//

import UIKit

final class CircleButton: UIButton {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makingButtonFullCircle()
    }
    
    
    // MARK: - Helper Functions
    
    func makingButtonFullCircle() {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.layer.masksToBounds = true
        
    }
    
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

}
