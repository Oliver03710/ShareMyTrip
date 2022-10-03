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
    case searchImage
    case destinationImage
    case tripHistoryImage
    case companionImage
}

enum startButtonImage: String, CaseIterable {
    case untapped = "travelBearMainButton"
    case tapped = "travelBearMainButtonTapped"
}

enum finishButtonImage: String, CaseIterable {
    case untapped = "finishTripButton"
    case tapped = "finishTripButtonTapped"
}

enum restoreButtonImage: String, CaseIterable {
    case fetchFileImage
}

enum IconImage: String, CaseIterable {
    case info, phone, location
}

enum TabBarButtonImage: String, CaseIterable {
    case mapButtonUntapped
    case mapButtonTapped
    case pinButtonUntapped
    case pinButtonTapped
    case companionButtonTapped
    case companionButtonUntapped
    case listButtonTapped
    case listButtonUntapped
    case extraButtonTapped
    case extraButtonUntapped
}
