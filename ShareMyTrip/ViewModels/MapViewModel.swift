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
    
    
    func removeAnnotations(_ mapView: MKMapView) {
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    func setRegionAndAnnotation(_ mapView: MKMapView, center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Test"
        
        mapView.addAnnotation(annotation)
        
    }
    
    func signIn(completion: @escaping () -> Void) {
        completion()
    }
    
}
