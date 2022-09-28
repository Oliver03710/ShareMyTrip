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
        
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        
        LocationHelper.standard.setRegion(mapView, lat: currentTrip[0].trips.last?.latitude, lon: currentTrip[0].trips.last?.longitude)
        LocationHelper.standard.setAnnotation(mapView, lat: currentTrip[0].trips.last?.latitude, lon: currentTrip[0].trips.last?.longitude)
        
//        LocationHelper.standard.setRegion(mapView, lat: CurrentTripRepository.standard.tasks.last?.latitude, lon: CurrentTripRepository.standard.tasks.last?.longitude)
//        LocationHelper.standard.setAnnotation(mapView, lat: CurrentTripRepository.standard.tasks.last?.latitude, lon: CurrentTripRepository.standard.tasks.last?.longitude)
        mapView.showAnnotations(mapView.annotations, animated: true)
        
        LocationHelper.standard.checkNumberOfAnnotations()
        
        if LocationHelper.standard.isTrue {
            
            LocationHelper.standard.routes.removeAll()
            LocationHelper.standard.createMultiplePath(mapView)
            
        }
    }
    
    func deleteButtonClicked(_ mapView: MKMapView, vc: UIViewController) {
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        
        vc.showAlertMessage {
            
            guard let anno = LocationHelper.standard.annotations.last, let lastItem = currentTrip[0].trips.last else { return }
            
            if !LocationHelper.standard.annotations.isEmpty && !LocationHelper.standard.routes.isEmpty {
                
                mapView.removeAnnotation(anno)
                mapView.removeOverlays(mapView.overlays)
                LocationHelper.standard.annotations.removeLast()
                LocationHelper.standard.routes.removeValue(forKey: lastItem.turn - 1)
                TripHistoryRepository.standard.deleteDestinationItem(item: lastItem)
                
            } else if LocationHelper.standard.annotations.count == 1 {
                
                LocationHelper.standard.annotations.removeAll()
                LocationHelper.standard.routes.removeAll()
                LocationHelper.standard.removeAnnotations(mapView)
                TripHistoryRepository.standard.deleteDestinationItem(item: lastItem)
                mapView.removeOverlays(mapView.overlays)
                
            }
            
        } deleteAllItem: {
            
            LocationHelper.standard.removeAnnotations(mapView)
            mapView.removeOverlays(mapView.overlays)
            currentTrip[0].trips.forEach { TripHistoryRepository.standard.deleteDestinationItem(item: $0) }
            
        } deleteAllWithTransition: {
            
            LocationHelper.standard.removeAnnotations(mapView)
            mapView.removeOverlays(mapView.overlays)
            currentTrip[0].trips.forEach { TripHistoryRepository.standard.deleteDestinationItem(item: $0) }
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
    
    func finishTripButtonTapped(_ mapView: MKMapView, vc: UIViewController) {
        
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        
        if currentTrip[0].trips.isEmpty {
            vc.showAlertMessage(title: "여행을 종료하시려면 목적지를 최소 1개 설정해주세요.")
        } else {
            vc.showAlertMessage {
                TripHistoryRepository.standard.finishTrip()
                LocationHelper.standard.removeAnnotations(mapView)
                mapView.removeOverlays(mapView.overlays)
                LocationHelper.standard.annotations.removeAll()
                LocationHelper.standard.routes.removeAll()
                
                UserdefaultsHelper.standard.removeAll()
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let vc = MainTapBarController()
                
                sceneDelegate?.window?.rootViewController = vc
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            
        }
        
    }
    
    func requestAPI() {
        
        if TouristAttractionsRepository.standard.tasks.isEmpty {
            TouristAttractionsAPIManager.requestTouristAttractions(pageNo: 1) { data, error in
                if let data = data {
                    for i in data.response.body.items {
                        guard let lat = Double(i.latitude), let lon = Double(i.longitude) else { return }
                        TouristAttractionsRepository.standard.addItem(name: i.name, address: i.address, introduction: i.introduction, admin: i.admin, phoneNumber: i.phoneNumber, latitude: lat, longitude: lon)
                    }
                }
            }
        }
        
    }
    
}
