//
//  SettingsTableViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/14.
//

import UIKit

import SnapKit

final class SettingsTableViewCell: BaseTableViewCell {

    // MARK: - Properties
    
    private let settingLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 15, text: nil)
        label.textColor = .black
        return label
    }()
    
    private let nextImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .black
        return iv
    }()
    
    private let versionLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 15, text: nil)
        label.textColor = .black
        return label
    }()
    
    
    // MARK: - Init
    
    private override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func setConstraints() {
        [settingLabel, nextImageView, versionLabel].forEach { contentView.addSubview($0) }
        
        settingLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(contentView.snp.width).dividedBy(2)
        }
        
        nextImageView.snp.makeConstraints { make in
            make.directionalVerticalEdges.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(nextImageView.snp.height)
        }

        versionLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(versionLabel.snp.height).multipliedBy(2)
        }
        
    }
    
    func setCellComponents(indexPath: IndexPath, isText: Bool = false) {
        versionLabel.isHidden = !isText
        nextImageView.isHidden = isText
        switch indexPath {
        case [0, 0]:
            settingLabel.text = SettingsDataTexts.allCases[indexPath.row].rawValue
        case [0, 1]:
            settingLabel.text = SettingsDataTexts.allCases[indexPath.row].rawValue
        case [1, 0]:
            settingLabel.text = SettingsToDevTexts.allCases[indexPath.row].rawValue
        case [1, 1]:
            settingLabel.text = SettingsToDevTexts.allCases[indexPath.row].rawValue
        case [2, 0]:
            settingLabel.text = SettingsInfoTexts.allCases[indexPath.row].rawValue
        case [2, 1]:
            settingLabel.text = SettingsInfoTexts.allCases[indexPath.row].rawValue
            versionLabel.isHidden = isText
            nextImageView.isHidden = !isText
            versionLabel.text = "1.0.0"
        default:
            break
        }
        
    }
    
}
