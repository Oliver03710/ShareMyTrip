//
//  CharacterImageView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/22.
//

import UIKit

final class CharacterImageView: UIImageView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ frame: CGRect, image: String, contentMode: UIView.ContentMode) {
        self.init(frame: frame)
        self.image = UIImage(named: image)
        self.contentMode = contentMode
    }

}
