//
//  RecommendationTableViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/27.
//

import UIKit

import SnapKit

final class RecommendationTableViewCell: BaseTableViewCell {

    // MARK: - Properties
    
    private let nameLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .semibold, fontSize: 16, text: nil, textAlignment: .center)
        label.textColor = #colorLiteral(red: 0.3490196078, green: 0.2431372549, blue: 0.1647058824, alpha: 1)
        return label
    }()
    
    private let addressLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 14, text: nil)
        label.numberOfLines = 0
        return label
    }()
    
    private let phoneNumLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 14, text: nil)
        return label
    }()
    
    private let introductionLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .thin, fontSize: 14, text: nil)
        label.numberOfLines = 0
        return label
    }()
    
    private let lineView: LineView = {
        let view = LineView(backgroundColor: #colorLiteral(red: 0.3490196078, green: 0.2431372549, blue: 0.1647058824, alpha: 1))
        return view
    }()
    
    private let infoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: IconImage.info.rawValue))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let locationImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: IconImage.location.rawValue))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let phoneImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: IconImage.phone.rawValue))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    // MARK: - Init
    
    private override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 1, green: 0.9450980392, blue: 0.8431372549, alpha: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func setConstraints() {
        
        [nameLabel, lineView, addressLabel, phoneNumLabel, introductionLabel, phoneImageView, locationImageView, infoImageView].forEach { self.contentView.addSubview($0) }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(12)
            make.directionalHorizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(17)
        }
        
        lineView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.height.equalTo(1)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(lineView.snp.bottom).offset(16)
            make.height.width.equalTo(16)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationImageView.snp.trailing).offset(12)
            make.centerY.equalTo(locationImageView.snp.centerY)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(15)
        }
        
        phoneImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(locationImageView.snp.bottom).offset(16)
            make.height.width.equalTo(16)
        }
        
        phoneNumLabel.snp.makeConstraints { make in
            make.leading.equalTo(phoneImageView.snp.trailing).offset(12)
            make.centerY.equalTo(phoneImageView.snp.centerY)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(15)
        }
        
        infoImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(phoneImageView.snp.bottom).offset(16)
            make.height.width.equalTo(16)
        }
        
        introductionLabel.snp.makeConstraints { make in
            make.leading.equalTo(infoImageView.snp.trailing).offset(12)
            make.top.equalTo(infoImageView.snp.top)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-16).priority(999)
        }
        
    }
    
    func setLabels(nameText: String?, addressText: String?, introductionText: String?, phoneNumText: String?) {
        
        nameLabel.text = nameText
        addressLabel.text = addressText
        
        guard let text = introductionText else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        introductionLabel.attributedText = attributedString
        
        phoneNumLabel.text = phoneNumText
    }

}

