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
        let label = BaseLabel(boldStyle: .semibold, fontSize: 15, text: nil)
        label.textColor = UIColor(red: 24/255, green: 111/255, blue: 174/255, alpha: 1)
        return label
    }()
    
    let addressLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 13, text: nil)
        label.textColor = .darkGray
        return label
    }()
    
    
    // MARK: - Init
    
    private override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 229/255, green: 244/255, blue: 249/255, alpha: 1)
        
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
