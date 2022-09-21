//
//  SharingListTableViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import UIKit

import SnapKit

final class SharingListTableViewCell: BaseTableViewCell {

    // MARK: - Properties
    
    let nameLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 15, text: nil)
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
    
    override func setConstraints() {
        self.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
    }
    
}
