//
//  StartingView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/20.
//

import UIKit

import SnapKit
import IQKeyboardManagerSwift

final class StartingView: BaseView {

    // MARK: - Properties
    
    private let characterImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: CharacterImage.main.rawValue))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let loadingLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .bold, fontSize: 24, text: "데이터를 로딩 중입니다...", textAlignment: .center)
        return label
    }()
    
    let viewModel = StartingViewModel()
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        
    }
    
    override func setConstraints() {
        [characterImageView, loadingLabel].forEach { self.addSubview($0) }
        
        characterImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
        
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(characterImageView.snp.centerY).multipliedBy(1.6)
            make.height.equalTo(26)
            make.width.equalTo(self.snp.width)
        }
    }

}
