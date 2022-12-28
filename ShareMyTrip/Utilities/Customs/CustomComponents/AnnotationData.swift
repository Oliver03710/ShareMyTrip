//
//  AnnotationData.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import MapKit

final class Annotation: MKPointAnnotation {
    var identifier: Int
    
    init(_ identifier: Int) {
        self.identifier = identifier
    }
}
