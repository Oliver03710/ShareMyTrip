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
        self.modalPresentationStyle = .fullScreen
        configureTabBars()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, CustomTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    private func configureTabBars() {
        viewControllers = [
            createNavController(for: MapViewController(), title: TabBarTitles.mapVC.rawValue, image: UIImage(named: TabBarButtonImage.mapButtonUntapped.rawValue), imageTapped: UIImage(named: TabBarButtonImage.mapButtonTapped.rawValue), backgroundColor: UIColor(red: 106/255, green: 216/255, blue: 0/255, alpha: 1)),
            createNavController(for: DestinationsViewController(), title: TabBarTitles.destinationVC.rawValue, image: UIImage(named: TabBarButtonImage.pinButtonUntapped.rawValue), imageTapped: UIImage(named: TabBarButtonImage.pinButtonTapped.rawValue), backgroundColor: UIColor(red: 64/255, green: 211/255, blue: 244/255, alpha: 1)),
            createNavController(for: CompanionsWithCVViewController(), title: TabBarTitles.sharingListVC.rawValue, image: UIImage(named: TabBarButtonImage.companionButtonUntapped.rawValue), imageTapped: UIImage(named: TabBarButtonImage.companionButtonTapped.rawValue), backgroundColor: UIColor(red: 255/255, green: 162/255, blue: 109/255, alpha: 1)),
            createNavController(for: HistoriesViewController(), title: TabBarTitles.historiesVC.rawValue, image: UIImage(named: TabBarButtonImage.listButtonUntapped.rawValue), imageTapped: UIImage(named: TabBarButtonImage.listButtonTapped.rawValue), backgroundColor: UIColor(red: 226/255, green: 162/255, blue: 109/255, alpha: 1)),
            createNavController(for: SettingsViewController(), title: TabBarTitles.SettingsVC.rawValue, image: UIImage(named: TabBarButtonImage.extraButtonUntapped.rawValue), imageTapped: UIImage(named: TabBarButtonImage.extraButtonTapped.rawValue), backgroundColor: UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1))
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage?, imageTapped: UIImage?, backgroundColor: UIColor?) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        navController.navigationBar.scrollEdgeAppearance = appearance
        
        navController.navigationBar.tintColor = .white
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = imageTapped
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        rootViewController.navigationItem.title = title
        
        return navController
    }
    
}
