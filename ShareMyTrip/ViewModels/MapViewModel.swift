//
//  MapViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import Foundation
import CoreLocation
import MapKit

class MapViewModel {
    
    var location: Observable<CLLocationCoordinate2D> = Observable(CLLocationCoordinate2D(latitude: 37.555908, longitude: 126.973262))
    var annotation: Observable<MKPointAnnotation> = Observable(MKPointAnnotation())
    var region: Observable<MKCoordinateRegion> = Observable(MKCoordinateRegion())
    
    func removeAnnotations(_ mapView: MKMapView) {
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    func setRegionAndAnnotation(_ mapView: MKMapView, center: CLLocationCoordinate2D) {
        
        region.value = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region.value, animated: true)
        
        annotation.value.coordinate = center
        annotation.value.title = "Test"
        
        mapView.addAnnotation(annotation.value)
        
    }
    
}
