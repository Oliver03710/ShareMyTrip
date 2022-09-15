//
//  SettingsTableViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/14.
//

import UIKit

import SnapKit

class SettingsTableViewCell: BaseTableViewCell {

    // MARK: - Properties
    
    let backUpLabel: SettingsVCLabel = {
        let label = SettingsVCLabel()
        return label
    }()
    
    let versionLabel: SettingsVCLabel = {
        let label = SettingsVCLabel()
        return label
    }()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        [backUpLabel, versionLabel].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        backUpLabel.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func setCellComponents(index: Int) {
        switch index {
        case 0: backUpLabel.text = SettingsLabelTexts.backUp.rawValue
        case 1: versionLabel.text = SettingsLabelTexts.version.rawValue
        default: break
        }
    }
    
}
