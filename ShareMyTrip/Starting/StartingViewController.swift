//
//  StartingViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/20.
//

import UIKit

final class StartingViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let startingView = StartingView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = startingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startingView.viewModel.TransitionAfterRequestAPI()
    }
    
}
