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
    
    
    // MARK: - Selectors
    
    @objc func confirmButtonTapped() {
        
        if startingView.viewModel.isValid.value {
            startingView.viewModel.transition(text: startingView.viewModel.nameText.value) {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let vc = MainTapBarController()
                
                sceneDelegate?.window?.rootViewController = vc
                sceneDelegate?.window?.makeKeyAndVisible()
            }
        }
    }
    
    @objc func namingTextFieldChanged() {
        if let text = startingView.namingTextField.text {
            startingView.viewModel.nameText.value = text
            startingView.viewModel.checkValidation()
        }
    }
    
    
    // MARK: - Helper Functions

    override func configureUI() {
        startingView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        startingView.namingTextField.addTarget(self, action: #selector(namingTextFieldChanged), for: .editingChanged)
    }
    
}
