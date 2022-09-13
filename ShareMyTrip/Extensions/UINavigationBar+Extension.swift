//
//  UINavigationBar+Extension.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

extension UIViewController {
    
    func setNaviBars( naviTitle: String?, naviBarTintColor: UIColor) {
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBackground
        navigationItem.scrollEdgeAppearance = barAppearance
        
        navigationItem.title = naviTitle
        self.navigationController?.navigationBar.tintColor = naviBarTintColor
        
    }
    
}
