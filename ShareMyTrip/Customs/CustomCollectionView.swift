//
//  CustomCollectionView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/30.
//

import UIKit

class CustomCollectionView: UICollectionView {

    // MARK: - Init
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, cellClass: AnyClass?, forCellReuseIdentifier identifier: String, delegate: UIViewController) {
        self.init(frame: frame, collectionViewLayout: layout)
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
        self.delegate = delegate as? any UICollectionViewDelegate
        self.dataSource = delegate as? any UICollectionViewDataSource
    }
    
    
    // MARK: - Helper Functions
    
    func collectionViewLayout(itemWidth: CGFloat, itemHeight: CGFloat, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat, sectionInsetTop: CGFloat, sectionInsetLeft: CGFloat, sectionInsetBottom: CGFloat, sectionInsetRight: CGFloat) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionInsetTop, left: sectionInsetLeft, bottom: sectionInsetBottom, right: sectionInsetRight)
        return layout
    }

}
