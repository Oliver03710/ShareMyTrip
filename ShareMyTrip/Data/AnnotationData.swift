//
//  AnnotationData.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import Foundation
import MapKit

class Annotation {
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    init(_ name: String, lat: CLLocationDegrees, lon: CLLocationDegrees) {
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
