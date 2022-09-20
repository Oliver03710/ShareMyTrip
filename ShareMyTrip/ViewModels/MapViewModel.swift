//
//  MapViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/21.
//

import Foundation
import MapKit

import PanModal

final class MapViewModel {
    
    // MARK: - Properties
    
    var isExecuted: Observable<Bool> = Observable(false)

    
    // MARK: - Helper Functions
    
    func searchTableViewRowSelected(_ mapView: MKMapView) {
        LocationHelper.standard.setRegion(mapView, lat: CurrentTripRepository.standard.tasks.last?.latitude, lon: CurrentTripRepository.standard.tasks.last?.longitude)
        LocationHelper.standard.setAnnotation(mapView, lat: CurrentTripRepository.standard.tasks.last?.latitude, lon: CurrentTripRepository.standard.tasks.last?.longitude)
        mapView.showAnnotations(mapView.annotations, animated: true)
        LocationHelper.standard.checkNumberOfAnnotations()
        if LocationHelper.standard.isTrue {
            LocationHelper.standard.routes.removeAll()
            LocationHelper.standard.createMultiplePath(mapView)
        }
    }
    
    func deleteButtonClicked(_ mapView: MKMapView, vc: UIViewController) {
        vc.showAlertMessage(buttonText: "삭제", alertTitle: "목적지를 지우시겠습니까?") {
            LocationHelper.standard.removeAnnotations(mapView)
            mapView.removeOverlays(mapView.overlays)
            CurrentTripRepository.standard.deleteAllItem()
        }
        UserdefaultsHelper.standard.removeAll()
        isExecuted.value = true
    }
    
    func searchButtonTapped(_ mapView: MKMapView, vcs: UIViewController) {
        isExecuted.value = true
        let vc = SearchViewController()
        vc.onDoneBlock = { _ in
            self.searchTableViewRowSelected(mapView)
        }
        vcs.presentPanModal(vc)
    }
    
    func createPathButtonTapped(_ mapView: MKMapView) {
        LocationHelper.standard.checkNumberOfAnnotations()
        if LocationHelper.standard.isTrue {
            LocationHelper.standard.showRoutes(mapView)
        }
    }
    
    func isExecutedFunc(identifier: Int, taskOrder: Int, annotationView: MKAnnotationView?, annotation: MKAnnotation) {
        if isExecuted.value {
            LocationHelper.standard.showAnnotations(identifier: identifier, taskOrder: taskOrder, annotationView: annotationView, annotation: annotation)
        } else {
            LocationHelper.standard.annotations.forEach {
                LocationHelper.standard.showAnnotations(identifier: identifier, taskOrder: $0.identifier - 1, annotationView: annotationView, annotation: annotation)
            }
        }
    }
    
}
