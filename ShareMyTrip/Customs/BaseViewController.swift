//
//  BaseViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        view.backgroundColor = .systemBackground
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() { }
    func setConstraints() { }

}
