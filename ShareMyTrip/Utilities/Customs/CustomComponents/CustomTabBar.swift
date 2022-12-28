//
//  CustomTabBar.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/04.
//

import UIKit

class CustomTabBar : UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = UIScreen.main.bounds.size.height / 9
        return sizeThatFits
    }
}
