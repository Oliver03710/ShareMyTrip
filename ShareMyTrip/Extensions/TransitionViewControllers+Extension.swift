//
//  TransitionViewControllers+Extension.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case presentOverFullScreen
        case present
        case presentNavigation
        case presentFullNavigation
        case push
    }
    
    func transitionViewController<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        
         switch transitionStyle {
         case .presentOverFullScreen:
             viewController.modalPresentationStyle = .overFullScreen
             self.present(viewController, animated: true)
        case .present:
             self.present(viewController, animated: true)
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
             self.present(navi, animated: true)
        case .presentFullNavigation:
             let nav = UINavigationController(rootViewController: viewController)
             nav.modalPresentationStyle = .fullScreen
             self.present(nav, animated: true)
        case .push:
             self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
