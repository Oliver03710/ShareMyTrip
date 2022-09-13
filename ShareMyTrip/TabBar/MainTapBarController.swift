//
//  MainTapBarController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

final class MainTapBarController: UITabBarController {
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().backgroundColor = .systemBackground
        tabBar.tintColor = .label
        configureTabBars()
    }
    
    
    // MARK: - Helper Functions
    
    private func configureTabBars() {
            viewControllers = [
                createNavController(for: MapViewController(), title: "지도", image: UIImage(systemName: "map.fill")),
                createNavController(for: SharingListViewController(), title: "같이 가는 사람들", image: UIImage(systemName: "person.3.fill")),
                createNavController(for: SettingsViewController(), title: "설정", image: UIImage(systemName: "gear"))
            ]
        }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
    
    
}


extension MainTapBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(#function)
    }
    
}
