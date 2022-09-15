//
//  BaseTableViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/14.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() { }
    func setConstraints() { }

}
