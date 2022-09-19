//
//  MapViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit
import MapKit
import CoreLocation

import SnapKit
import PanModal

final class MapViewController: BaseViewController {
    
    // MARK: - Properties
    
    private lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        mv.showsUserLocation = true
        return mv
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        return lm
    }()
    
    private lazy var deleteButton: BaseButton = {
        let btn = BaseButton(backgroundColor: .red, titleOrImage: "trash", hasTitle: false, componentColor: .white, addTarget: self, action: #selector(deleteButtonTapped))
        return btn
    }()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Selectors
    
    @objc private func searchButtonTapped() {
        let vc = SearchViewController()
        vc.onDoneBlock = { _ in
            
            LocationHelper.standard.setRegion(self.mapView, lat: CurrentTripRepository.standard.tasks.last?.latitude, lon: CurrentTripRepository.standard.tasks.last?.longitude)
            LocationHelper.standard.setAnnotation(self.mapView, lat: CurrentTripRepository.standard.tasks.last?.latitude, lon: CurrentTripRepository.standard.tasks.last?.longitude)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            LocationHelper.standard.checkNumberOfAnnotations()
            if LocationHelper.standard.isTrue {
                LocationHelper.standard.routes.removeAll()
                LocationHelper.standard.createMultiplePath(self.mapView)
            }
        }
        presentPanModal(vc)
    }
    
    @objc private func deleteButtonTapped() {
        showAlertMessage(buttonText: "삭제", alertTitle: "목적지를 지우시겠습니까?") {
            LocationHelper.standard.removeAnnotations(self.mapView)
            self.mapView.removeOverlays(self.mapView.overlays)
            CurrentTripRepository.standard.deleteAllItem()
        }
    }
    
    @objc private func createPathButtonTapped() {
        LocationHelper.standard.checkNumberOfAnnotations()
        if LocationHelper.standard.isTrue {
            LocationHelper.standard.showRoutes(mapView)
        }
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        setNaviButtons()
        CurrentTripRepository.standard.fetchRealmData()
        if let task = CurrentTripRepository.standard.tasks {
            print(task)
        }
        print("Realm is located at:", CurrentTripRepository.standard.localRealm.configuration.fileURL!)
    }
    
    override func setContraints() {
        view.addSubview(mapView)
        mapView.addSubview(deleteButton)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(mapView.snp.leading).inset(20)
            make.bottom.equalTo(mapView.snp.bottom).inset(20)
            make.height.width.equalTo(44)
        }
    }
    
    private func setNaviButtons() {
        let searchBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        let routeBarButton = UIBarButtonItem(title: "경로보기", style: .plain, target: self, action: #selector(createPathButtonTapped))
        navigationItem.leftBarButtonItem = routeBarButton
        navigationItem.rightBarButtonItem = searchBarButton
        navigationController?.navigationBar.tintColor = .systemBrown
    }
    
    private func showAnnotations() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
}


// MARK: - Extension: Location Authorization

private extension MapViewController {
    
    private func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있습니다.")
        }
    }
    
    private func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined:
            print("NOT Determined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Denied")
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            print("When In Use")
            locationManager.startUpdatingLocation()
        default:
            print("Default")
        }
    }
}


// MARK: - Extension: CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보 불러오는데 실패했습니다.")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
}


// MARK: - Extension: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5
        renderer.strokeColor = .systemBlue
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Annotation else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "\(annotation.identifier)")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "\(annotation.identifier)")
        } else {
            annotationView?.annotation = annotation
        }
        
        if annotation.identifier == CurrentTripRepository.standard.tasks[CurrentTripRepository.standard.tasks.count - 1].turn {
            annotationView?.image = UIImage(named: CustomAnnotations.allCases[CurrentTripRepository.standard.tasks.count - 1].rawValue)
            annotationView?.annotation = LocationHelper.standard.annotations[CurrentTripRepository.standard.tasks.count - 1]
        }
        
        return annotationView
    }
    
}
