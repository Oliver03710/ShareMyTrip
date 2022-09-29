//
//  BackupTableViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/28.
//

import UIKit

import SnapKit

final class BackupTableViewCell: BaseTableViewCell {

    // MARK: - Properties
    
    let backupDataLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .semibold, fontSize: 15, text: nil)
        return label
    }()
    
    
    // MARK: - Init
    
    private override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        [backupDataLabel].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        backupDataLabel.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
    }
    
}
