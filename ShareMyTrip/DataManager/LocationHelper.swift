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
    func setRegion(_ mapView: MKMapView, lat: CLLocationDegrees?, lon: CLLocationDegrees?)
    func setAnnotation(_ mapView: MKMapView, lat: CLLocationDegrees?, lon: CLLocationDegrees?)
    func setAnnotation(_ mapView: MKMapView, lat: CLLocationDegrees?, lon: CLLocationDegrees?, turn: Int)
    func loadAnnotations(_ mapView: MKMapView)
    func createPath(_ mapView: MKMapView, sourceLat: CLLocationDegrees, sourceLon: CLLocationDegrees, destinationLat: CLLocationDegrees, destinationLon: CLLocationDegrees, turn: Int)
    func showRoutes(_ mapView: MKMapView)
    func createMultiplePath(_ mapView: MKMapView)
    func showAnnotations(identifier: Int, taskOrder: Int, annotationView: MKAnnotationView?, annotation: MKAnnotation)
}

final class LocationHelper: LocationHelperType {
    
    private init() { }
    
    static let standard = LocationHelper()
    
    // MARK: - Properties
    
    var routes = [Int: MKRoute]()
    var isTrue = false
    var annotations = [Annotation]()
    
    
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
    
    func setRegion(_ mapView: MKMapView, lat: CLLocationDegrees?, lon: CLLocationDegrees?) {
        guard let lat = lat, let lon = lon else { return }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    func setAnnotation(_ mapView: MKMapView, lat: CLLocationDegrees?, lon: CLLocationDegrees?) {
        guard let lat = lat, let lon = lon else { return }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let annotation = Annotation(CurrentTripRepository.standard.tasks[CurrentTripRepository.standard.tasks.count - 1].turn)
        annotation.coordinate = center
        annotation.title = CurrentTripRepository.standard.tasks[CurrentTripRepository.standard.tasks.count - 1].name
        annotation.subtitle = CurrentTripRepository.standard.tasks[CurrentTripRepository.standard.tasks.count - 1].address
        annotations.append(annotation)
        mapView.addAnnotations(annotations)
    }
    
    func setAnnotation(_ mapView: MKMapView, lat: CLLocationDegrees?, lon: CLLocationDegrees?, turn: Int) {
        guard let lat = lat, let lon = lon else { return }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let annotation = Annotation(CurrentTripRepository.standard.tasks[turn - 1].turn)
        annotation.coordinate = center
        annotation.title = CurrentTripRepository.standard.tasks[turn - 1].name
        annotation.subtitle = CurrentTripRepository.standard.tasks[turn - 1].address
        annotations.append(annotation)
    }
    
    func loadAnnotations(_ mapView: MKMapView) {
        CurrentTripRepository.standard.tasks.forEach { setAnnotation(mapView, lat: $0.latitude, lon: $0.longitude, turn: $0.turn) }
        LocationHelper.standard.checkNumberOfAnnotations()
        if LocationHelper.standard.isTrue {
            LocationHelper.standard.routes.removeAll()
            LocationHelper.standard.createMultiplePath(mapView)
        }
        dump(annotations)
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func createPath(_ mapView: MKMapView, sourceLat: CLLocationDegrees, sourceLon: CLLocationDegrees, destinationLat: CLLocationDegrees, destinationLon: CLLocationDegrees, turn: Int) {
        
        let sourceLocation = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLon)
        let destinationLocation = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLon)
        
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
            self.routes.updateValue(response.routes[0], forKey: turn)
        }
    }
    
    func showRoutes(_ mapView: MKMapView) {
        routes.forEach { mapView.addOverlay($0.value.polyline, level: MKOverlayLevel.aboveRoads) }
    }
    
    func createMultiplePath(_ mapView: MKMapView) {
        for i in 1...annotations.count - 1 {
            createPath(mapView, sourceLat: annotations[i - 1].coordinate.latitude, sourceLon: annotations[i - 1].coordinate.longitude, destinationLat: annotations[i].coordinate.latitude, destinationLon: annotations[i].coordinate.longitude, turn: i)
        }
    }
    
    func showAnnotations(identifier: Int, taskOrder: Int, annotationView: MKAnnotationView?, annotation: MKAnnotation) {
        if identifier == CurrentTripRepository.standard.tasks[taskOrder].turn {
            annotationView?.image = UIImage(named: "customAnno\(CustomAnnotations.allCases[taskOrder].rawValue)")
            annotationView?.annotation = LocationHelper.standard.annotations[taskOrder]
            annotationView?.canShowCallout = true
            annotationView?.detailCalloutAccessoryView = Callout(annotation: annotation)
        }
    }
    
}
