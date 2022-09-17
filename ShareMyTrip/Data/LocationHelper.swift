//
//  LocationHelper.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/16.
//

import Foundation
import MapKit

private protocol LocationHelperType: AnyObject {
    func checkNumberOfAnnotations()
    func removeAnnotations(_ mapView: MKMapView)
    func setRegion(_ mapView: MKMapView, center: CLLocationCoordinate2D)
    func setAnnotation(_ mapView: MKMapView, center: CLLocationCoordinate2D)
    func createPath(_ mapView: MKMapView, sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D)
    func showRoutes(_ mapView: MKMapView, routes: [MKRoute])
    func createMultiplePath(_ mapView: MKMapView)
}

public final class LocationHelper: LocationHelperType {
    
    private init() { }
    
    public static let standard = LocationHelper()
    
    // MARK: - Properties
    
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.555908, longitude: 126.973262)
    var annotations = [MKPointAnnotation]()
    var region: MKCoordinateRegion = MKCoordinateRegion()
    var routes = [MKRoute]()
    var isTrue = false
    
    
    // MARK: - Helper Functions
    
    func checkNumberOfAnnotations() {
        if annotations.count >= 2 {
            isTrue = true
        } else {
            isTrue = false
        }
    }
    
    func removeAnnotations(_ mapView: MKMapView) {
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
        annotations.removeAll()
    }
    
    func setRegion(_ mapView: MKMapView, center: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    func setAnnotation(_ mapView: MKMapView, center: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Test"
        
        annotations.append(annotation)
        mapView.addAnnotations(annotations)
        
    }
    
    func createPath(_ mapView: MKMapView, sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D) {
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .any
        
        let direction = MKDirections(request: directionRequest)
        direction.calculate { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error Found: \(error.localizedDescription)")
                }
                return
            }
            
            self.routes.append(response.routes[0])
            print(self.routes)
        }
    }
    
    func showRoutes(_ mapView: MKMapView, routes: [MKRoute]) {
        routes.forEach { mapView.addOverlay($0.polyline, level: MKOverlayLevel.aboveRoads) }
    }
    
    func createMultiplePath(_ mapView: MKMapView) {
        for i in 1...annotations.count - 1 {
            createPath(mapView, sourceLocation: annotations[i - 1].coordinate, destinationLocation: annotations[i].coordinate)
        }
    }
    
}
