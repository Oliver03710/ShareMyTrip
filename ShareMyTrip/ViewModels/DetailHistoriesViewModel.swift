//
//  DetailHistoriesViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/03.
//

import Foundation
import MapKit

final class DetailHistoriesViewModel {
    
    // MARK: - Properties
    
    var isExecuted: Observable<Bool> = Observable(false)

    
    // MARK: - Helper Functions
    
    func deleteSpecificTrip(_ mapView: MKMapView, index: Int, vc: UIViewController) {
        
        let tripHistory = TripHistoryRepository.standard.fetchTripHistory()
        
        LocationHelper.standard.removeAnnotations(mapView, status: .past)
        mapView.removeOverlays(mapView.overlays)
        TripHistoryRepository.standard.deleteItem(item: tripHistory[index])
    }
    
    func showCustomAnno(identifier: Int, taskOrder: Int, annotationView: MKAnnotationView?, annotation: MKAnnotation, index: Int) {
        
        let tripHistory = TripHistoryRepository.standard.fetchTripHistory()
        if tripHistory[index].trips.count > 1 {
            LocationHelper.standard.historyAnnotations.forEach {
                LocationHelper.standard.showAnnotations(identifier: identifier, taskOrder: $0.identifier - 1, annotationView: annotationView, annotation: annotation, index: index, status: .past)
            }
        } else {
            LocationHelper.standard.showAnnotations(identifier: identifier, taskOrder: taskOrder, annotationView: annotationView, annotation: annotation, index: index, status: .past)
        }
        
    }
    
}
