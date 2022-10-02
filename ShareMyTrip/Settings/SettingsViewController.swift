//
//  SettingsViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit
import MapKit

import PanModal

final class SettingsViewController: BaseViewController {

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
        settingsView.transitionVC = {
            let vc = BackupViewController()
            self.presentPanModal(vc)
        }
    }

}
