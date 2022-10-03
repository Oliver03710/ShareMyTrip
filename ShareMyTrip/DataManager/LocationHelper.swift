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
    func removeAnnotations(_ mapView: MKMapView, status: TripStatus)
    func setRegion(_ mapView: MKMapView, lat: CLLocationDegrees?, lon: CLLocationDegrees?)
    func setAnnotation(_ mapView: MKMapView, lat: CLLocationDegrees?, lon: CLLocationDegrees?)
    func setAnnotation(_ mapView: MKMapView, lat: CLLocationDegrees?, lon: CLLocationDegrees?, turn: Int, index: Int?, status: TripStatus)
    func loadAnnotations(_ mapView: MKMapView, index: Int?, status: TripStatus)
    func createPath(_ mapView: MKMapView, sourceLat: CLLocationDegrees, sourceLon: CLLocationDegrees, destinationLat: CLLocationDegrees, destinationLon: CLLocationDegrees, turn: Int, status: TripStatus)
    func showRoutes(_ mapView: MKMapView, status: TripStatus)
    func createMultiplePath(_ mapView: MKMapView, status: TripStatus)
    func showAnnotations(identifier: Int, taskOrder: Int, annotationView: MKAnnotationView?, annotation: MKAnnotation, index: Int?, status: TripStatus)
}

enum TripStatus {
    case current, past
}

final class LocationHelper: LocationHelperType {
    
    private init() { }
    
    static let standard = LocationHelper()
    
    // MARK: - Properties
    
    var routes = [Int: MKRoute]()
    var isTrue = false
    var annotations = [Annotation]()
    
    var historyRoutes = [Int: MKRoute]()
    var historyAnnotations = [Annotation]()
    
    
    // MARK: - Helper Functions
    
    func checkNumberOfAnnotations() {
        isTrue = annotations.count >= 2 ? true : false
    }
    
    func removeAnnotations(_ mapView: MKMapView, status: TripStatus) {
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
        switch status {
        case .current: annotations.removeAll()
        case .past: historyAnnotations.removeAll()
        }
        
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
        
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        
        let annotation = Annotation(currentTrip[0].trips[currentTrip[0].trips.count - 1].turn)
        annotation.coordinate = center
        annotation.title = currentTrip[0].trips[currentTrip[0].trips.count - 1].name
        annotation.subtitle = currentTrip[0].trips[currentTrip[0].trips.count - 1].address
        
        annotations.append(annotation)
        mapView.addAnnotations(annotations)
    }
    
    func setAnnotation(_ mapView: MKMapView, lat: CLLocationDegrees?, lon: CLLocationDegrees?, turn: Int, index: Int?, status: TripStatus) {
        
        guard let lat = lat, let lon = lon else { return }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        switch status {
        case .current:
            
            let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
            
            let annotation = Annotation(currentTrip[0].trips[turn - 1].turn)
            annotation.coordinate = center
            annotation.title = currentTrip[0].trips[turn - 1].name
            annotation.subtitle = currentTrip[0].trips[turn - 1].address
            annotations.append(annotation)
            
        case .past:
            
            let tripHistory = TripHistoryRepository.standard.fetchTripHistory()
            guard let index = index else { return }
            
            let annotation = Annotation(tripHistory[index].trips[turn - 1].turn)
            annotation.coordinate = center
            annotation.title = tripHistory[index].trips[turn - 1].name
            annotation.subtitle = tripHistory[index].trips[turn - 1].address
            historyAnnotations.append(annotation)
            
        }
        
    }
    
    func loadAnnotations(_ mapView: MKMapView, index: Int?, status: TripStatus) {
        
        switch status {
        case .current:
            let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
            
            currentTrip[0].trips.forEach {
                setAnnotation(mapView, lat: $0.latitude, lon: $0.longitude, turn: $0.turn, index: index, status: .current)
            }
            checkNumberOfAnnotations()
            if isTrue {
                routes.removeAll()
                createMultiplePath(mapView, status: .current)
            }
            
            mapView.addAnnotations(annotations)
            
        case .past:
            
            historyAnnotations.removeAll()
            let tripHistory = TripHistoryRepository.standard.fetchTripHistory()
            guard let index = index else { return }
            
            tripHistory[index].trips.forEach {
                setAnnotation(mapView, lat: $0.latitude, lon: $0.longitude, turn: $0.turn, index: index, status: .past)
            }
            if historyAnnotations.count >= 2 {
                historyRoutes.removeAll()
                createMultiplePath(mapView, status: .past)
            }
            mapView.addAnnotations(self.historyAnnotations)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
        print(historyAnnotations)
    }
    
    func createPath(_ mapView: MKMapView, sourceLat: CLLocationDegrees, sourceLon: CLLocationDegrees, destinationLat: CLLocationDegrees, destinationLon: CLLocationDegrees, turn: Int, status: TripStatus) {
        
        let sourceLocation = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLon)
        let destinationLocation = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLon)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        let direction = MKDirections(request: directionRequest)
        direction.calculate { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error Found: \(error.localizedDescription)")
                }
                return
            }
            
            switch status {
            case .current:
                self.routes.updateValue(response.routes[0], forKey: turn)
            case .past:
                self.historyRoutes.updateValue(response.routes[0], forKey: turn)
            }
        }
    }
    
    func showRoutes(_ mapView: MKMapView, status: TripStatus) {
        switch status {
        case .current:
            routes.forEach { mapView.addOverlay($0.value.polyline, level: MKOverlayLevel.aboveRoads) }
        case .past:
            historyRoutes.forEach { mapView.addOverlay($0.value.polyline, level: MKOverlayLevel.aboveRoads) }
        }
    }
    
    func createMultiplePath(_ mapView: MKMapView, status: TripStatus) {
        switch status {
        case .current:
            for i in 1...annotations.count - 1 {
                createPath(mapView, sourceLat: annotations[i - 1].coordinate.latitude, sourceLon: annotations[i - 1].coordinate.longitude, destinationLat: annotations[i].coordinate.latitude, destinationLon: annotations[i].coordinate.longitude, turn: i, status: .current)
            }
        case .past:
            for i in 1...historyAnnotations.count - 1 {
                createPath(mapView, sourceLat: historyAnnotations[i - 1].coordinate.latitude, sourceLon: historyAnnotations[i - 1].coordinate.longitude, destinationLat: historyAnnotations[i].coordinate.latitude, destinationLon: historyAnnotations[i].coordinate.longitude, turn: i, status: .past)
            }
        }
        
    }
    
    func showAnnotations(identifier: Int, taskOrder: Int, annotationView: MKAnnotationView?, annotation: MKAnnotation, index: Int?, status: TripStatus) {
        
        switch status {
        case .current:
            let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
            
            if identifier == currentTrip[0].trips[taskOrder].turn {
                annotationView?.image = UIImage(named: "customAnno\(CustomAnnotations.allCases[taskOrder].rawValue)")
                annotationView?.annotation = LocationHelper.standard.annotations[taskOrder]
                annotationView?.canShowCallout = true
                annotationView?.detailCalloutAccessoryView = Callout(annotation: annotation)
            }
        case .past:
            let tripHistory = TripHistoryRepository.standard.fetchTripHistory()
            guard let index = index else { return }
            
            if identifier == tripHistory[index].trips[taskOrder].turn {
                annotationView?.image = UIImage(named: "customAnno\(CustomAnnotations.allCases[taskOrder].rawValue)")
                annotationView?.annotation = LocationHelper.standard.historyAnnotations[taskOrder]
                annotationView?.canShowCallout = true
                annotationView?.detailCalloutAccessoryView = Callout(annotation: annotation)
            }
        }
    }
    
}
