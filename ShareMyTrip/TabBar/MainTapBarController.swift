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
            createNavController(for: MapViewController(), title: TabBarTitles.mapVC.rawValue, image: UIImage(systemName: TabBarImages.mapVC.rawValue)),
            createNavController(for: DestinationsViewController(), title: TabBarTitles.destinationVC.rawValue, image: UIImage(systemName: TabBarImages.destinationVC.rawValue)),
            createNavController(for: SharingListViewController(), title: TabBarTitles.sharingListVC.rawValue, image: UIImage(systemName: TabBarImages.sharingListVC.rawValue)),
            createNavController(for: HistoriesViewController(), title: TabBarTitles.historiesVC.rawValue, image: UIImage(systemName: TabBarImages.historiesVC.rawValue)),
            createNavController(for: SettingsViewController(), title: TabBarTitles.SettingsVC.rawValue, image: UIImage(systemName: TabBarImages.SettingsVC.rawValue))
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
