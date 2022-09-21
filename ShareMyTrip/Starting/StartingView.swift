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
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let namingTextField: BaseTextField = {
        let tf = BaseTextField(placeHolder: "여행 이름을 등록해주세요!", colorOfPlaceHolder: UIColor.darkGray, borderStyle: .roundedRect, backgroundColor: .white, textColor: .black)
        return tf
    }()
    
    private let titleLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .bold, fontSize: 35, text: "여행가자", textAlignment: .center)
        return label
    }()
    
    private let emphasizedTitleLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .heavy, fontSize: 50, text: "곰!", textAlignment: .center)
        label.textColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        return label
    }()
    
    let confirmButton: BaseButton = {
        let btn = BaseButton(buttonTitle: "여행하기", textColor: .black, backgroundColor: .systemBrown, cornerRadius: 8)
        return btn
    }()
    
    let viewModel = StartingViewModel()
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemCyan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        viewModel.activateButton(confirmButton)
        viewModel.bindsTextField(namingTextField)
    }
    
    override func setConstraints() {
        [characterImageView, namingTextField, titleLabel, emphasizedTitleLabel, confirmButton].forEach { self.addSubview($0) }
        
        characterImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
        
        namingTextField.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(characterImageView.snp.centerY).multipliedBy(1.45)
            make.height.equalTo(44)
            make.width.equalTo(self.snp.width).multipliedBy(0.7)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(namingTextField.snp.bottom).multipliedBy(1.05)
            make.height.equalTo(44)
            make.width.equalTo(80)
        }

        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX).multipliedBy(0.82)
            make.centerY.equalTo(characterImageView.snp.centerY).multipliedBy(0.4)
            make.height.equalTo(35)
            make.width.equalTo(125)
        }
        
        emphasizedTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(50)
            make.width.equalTo(80)
        }
    }

}
