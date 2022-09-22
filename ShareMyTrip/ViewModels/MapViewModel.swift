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
        vc.showAlertMessage {
            
            guard let anno = LocationHelper.standard.annotations.last, let lastItem = CurrentTripRepository.standard.tasks.last else { return }
            
            if !LocationHelper.standard.annotations.isEmpty && !LocationHelper.standard.routes.isEmpty {
                
                mapView.removeAnnotation(anno)
                mapView.removeOverlays(mapView.overlays)
                LocationHelper.standard.annotations.removeLast()
                LocationHelper.standard.routes.removeValue(forKey: lastItem.turn - 1)
                CurrentTripRepository.standard.deleteLastItem(item: lastItem)
                
            } else if LocationHelper.standard.annotations.count == 1 {
                
                LocationHelper.standard.annotations.removeAll()
                LocationHelper.standard.routes.removeAll()
                LocationHelper.standard.removeAnnotations(mapView)
                CurrentTripRepository.standard.deleteLastItem(item: lastItem)
                mapView.removeOverlays(mapView.overlays)
                
            }
            
        } deleteAllItem: {
            
            LocationHelper.standard.removeAnnotations(mapView)
            mapView.removeOverlays(mapView.overlays)
            CurrentTripRepository.standard.tasks.forEach { CurrentTripRepository.standard.deleteLastItem(item: $0) }
            
        } deleteAllWithTransition: {
            
            LocationHelper.standard.removeAnnotations(mapView)
            mapView.removeOverlays(mapView.overlays)
            CurrentTripRepository.standard.tasks.forEach { CurrentTripRepository.standard.deleteLastItem(item: $0) }
            UserdefaultsHelper.standard.removeAll()
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let vc = StartingViewController()
            
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
            
        }
        
    }
    
    func searchButtonTapped(_ mapView: MKMapView, vcs: UIViewController) {
        
        isExecuted.value = true
        let vc = SearchViewController()
        vc.tableView.isHidden = true
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
    
    func finishTripButtonTapped(_ mapView: MKMapView) {
        
        var destinations = [String](), companions = [String](), addresses = [String]()
        
        if !CurrentTripRepository.standard.tasks.isEmpty && !CompanionsRepository.standard.tasks.isEmpty {
            
            CurrentTripRepository.standard.tasks.forEach {
                destinations.append($0.name)
                addresses.append($0.address)
            }
            CompanionsRepository.standard.tasks.forEach { companions.append($0.companion) }
            print(destinations)
            print(companions)
            print(addresses)
            TripHistoryRepository.standard.addItem(tripName: UserdefaultsHelper.standard.tripName, desnitations: destinations, companions: companions, addresses: addresses)
            TripHistoryRepository.standard.fetchRealmData()
            
            LocationHelper.standard.removeAnnotations(mapView)
            mapView.removeOverlays(mapView.overlays)
            LocationHelper.standard.annotations.removeAll()
            LocationHelper.standard.routes.removeAll()
            
            CurrentTripRepository.standard.tasks.forEach {
                destinations.append($0.name)
                addresses.append($0.address)
            }
            CompanionsRepository.standard.tasks.forEach { CompanionsRepository.standard.deleteSpecificItem(item: $0) }
            CurrentTripRepository.standard.tasks.forEach { CurrentTripRepository.standard.deleteLastItem(item: $0) }
            UserdefaultsHelper.standard.removeAll()
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let vc = StartingViewController()

            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
            
        }
        
    }
    
}
