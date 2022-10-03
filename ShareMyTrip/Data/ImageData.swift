//
//  ImageData.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/20.
//

import Foundation

enum CharacterImage: String, CaseIterable {
    case main = "travelBearMainBlue"
    case smile = "smileFace"
    case crying = "cryingFace"
}

enum startButtonImage: String, CaseIterable {
    case untapped = "travelBearMainButton"
    case tapped = "travelBearMainButtonTapped"
}

enum IconImage: String, CaseIterable {
    case info, phone, location
}
