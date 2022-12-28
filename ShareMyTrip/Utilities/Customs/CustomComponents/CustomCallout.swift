//
//  CustomCallout.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import MapKit

final class Callout: UIView {
    
    private let subtitleLabel = UILabel(frame: .zero)
    private let annotation: MKAnnotation
    
    init(annotation: MKAnnotation) {
        self.annotation = annotation
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        setupSubtitle()
    }
    
    private func setupSubtitle() {
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        subtitleLabel.text = annotation.subtitle as? String
        addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        subtitleLabel.widthAnchor.constraint(equalToConstant: 350).isActive = true
    }
    
}
