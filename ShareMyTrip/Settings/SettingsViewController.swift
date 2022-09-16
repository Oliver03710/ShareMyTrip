//
//  SettingsViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

class SettingsViewController: BaseViewController {

    // MARK: - Properties
    
    let settingsView = SettingsView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        
    }

}
