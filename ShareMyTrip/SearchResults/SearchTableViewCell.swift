//
//  SearchTableViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/15.
//

import UIKit

import SnapKit

class SearchTableViewCell: BaseTableViewCell {

    // MARK: - Properties
    
    let titleLabel: BaseLabel = {
        let label = BaseLabel(fontSize: 13)
        return label
    }()
    
    let addressLabel: BaseLabel = {
        let label = BaseLabel(fontSize: 13)
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
        [titleLabel, addressLabel].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
        }
    }
    
    func setCellComponents(title: String, subTitle: String) {
        titleLabel.text = title
        addressLabel.text = subTitle
    }

}
