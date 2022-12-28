//
//  SearchTableViewCell.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/15.
//

import UIKit

import SnapKit

final class SearchTableViewCell: BaseTableViewCell {

    // MARK: - Properties
    
    private let titleLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 15, text: nil)
        return label
    }()
    
    private let addressLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .regular, fontSize: 13, text: nil)
        label.textColor = .gray
        return label
    }()
    
//    private lazy var stackView: CustomStackView = {
//        let sv = CustomStackView(arrangedSubviews: [titleLabel, addressLabel], axis: .vertical, spacing: 8, distribution: .equalSpacing)
//        sv.alignment = .leading
//        return sv
//    }()
    
    
    // MARK: - Init
    
    private override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func setConstraints() {
        [titleLabel, addressLabel].forEach { addSubview($0) }
        
//        stackView.snp.makeConstraints { make in
//            make.edges.equalTo(self.safeAreaLayoutGuide).inset(8)
//        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.directionalHorizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(16)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide).inset(8)
            
        }
    }
    
    func setCellComponents(title: String, subTitle: String) {
        titleLabel.text = title
        addressLabel.text = subTitle
    }

}
