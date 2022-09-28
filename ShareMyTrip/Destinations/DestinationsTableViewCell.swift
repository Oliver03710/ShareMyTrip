//
//  DestinationsTableViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/21.
//

import UIKit

import SnapKit

final class DestinationsTableViewCell: BaseTableViewCell {

    // MARK: - Properties
    
    let nameLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 15, text: nil)
        return label
    }()
    
    let addressLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 13, text: nil)
        label.textColor = .gray
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
        
        [nameLabel, addressLabel].forEach { addSubview($0) }
        
        nameLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.top.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(16)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
    }

}
