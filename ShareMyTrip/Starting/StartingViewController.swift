//
//  StartingViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/20.
//

import UIKit

import SnapKit

final class StartingViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let characterImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: CharacterImage.main.rawValue))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let loadingLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .bold, fontSize: 20, text: "데이터를 로딩 중입니다...", textAlignment: .center)
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: startButtonImage.untapped.rawValue), for: .normal)
        btn.setImage(UIImage(named: startButtonImage.tapped.rawValue), for: .highlighted)
        btn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    let viewModel = StartingViewModel()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bindingIsFinished(loadingLabel, button: startButton)
        viewModel.TransitionAfterRequestAPI()
        print(viewModel.isFinished.value)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    // MARK: - Selectors
    
    @objc func startButtonTapped() {
        viewModel.isFinished.value = false
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let vc = MainTapBarController()
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()

    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        
    }
    
    override func setConstraints() {
        [characterImageView, loadingLabel, startButton].forEach { view.addSubview($0) }
        
        characterImageView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(characterImageView.snp.centerY).multipliedBy(1.7)
            make.height.equalTo(26)
            make.width.equalTo(view.snp.width)
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(characterImageView.snp.centerY).multipliedBy(1.7)
            make.width.equalTo(view.snp.width).dividedBy(2.3)
            make.height.equalTo(startButton.snp.width).dividedBy(2.4)
        }
    }
    
}
