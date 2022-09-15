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
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        mv.showsUserLocation = true
        return mv
    }()
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        return lm
    }()
    
    lazy var searchButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("검색", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private var currentPlace: CLPlacemark?
    private var sourceLocation = CLLocationCoordinate2D(latitude: 37.555908, longitude: 126.973262)
    private let mapViewModel = MapViewModel()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Selectors
    
    @objc func searchButtonTapped() {
        let vc = SearchViewController()
        vc.mapViewModel = mapViewModel
        vc.onDoneBlock = { _ in
            self.mapViewModel.removeAnnotations(self.mapView)
            self.mapViewModel.setRegionAndAnnotation(self.mapView, center: self.mapViewModel.location.value)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        presentPanModal(vc)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        [mapView].forEach { view.addSubview($0) }
        mapView.addSubview(searchButton)
    }
    
    override func setContraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchButton.snp.makeConstraints { make in
            make.trailing.equalTo(mapView.snp.trailing).inset(20)
            make.bottom.equalTo(mapView.snp.bottom).inset(20)
            make.height.width.equalTo(44)
        }
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Test"
        
        mapView.addAnnotation(annotation)
        
    }
    
    func removeAnnotations() {
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
}


// MARK: - Extension: Location Authorization

extension MapViewController {
    
    func checkUserDeviceLocationServiceAuthorization() {
        
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
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
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
            setRegionAndAnnotation(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
}


// MARK: - Extension: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
}
