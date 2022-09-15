//
//  BaseTableView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/14.
//

import UIKit

class BaseTableView: UITableView {

    // MARK: - Init
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    func configureUI() {
        self.keyboardDismissMode = .onDrag
    }
    
    convenience init(frame: CGRect, style: UITableView.Style, cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        self.init(frame: frame, style: style)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    

}
