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
        mv.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
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
    
    lazy var deleteButton: UIButton = {
        let btn = UIButton()
        // fix this button
        btn.clipsToBounds = true
        btn.layer.cornerRadius = btn.bounds.size.width / 2
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        btn.backgroundColor = .red
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var CreatePathButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("경로찾기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBrown
        btn.addTarget(self, action: #selector(createPathButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private var currentPlace: CLPlacemark?
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Selectors
    
    @objc func searchButtonTapped() {
        let vc = SearchViewController()
        vc.onDoneBlock = { _ in
            LocationHelper.standard.setRegion(self.mapView, center: LocationHelper.standard.location)
            LocationHelper.standard.setAnnotation(self.mapView, center: LocationHelper.standard.location)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            LocationHelper.standard.checkNumberOfAnnotations()
            if LocationHelper.standard.isTrue {
                LocationHelper.standard.routes.removeAll()
                for i in 1...LocationHelper.standard.annotations.count - 1 {
                    LocationHelper.standard.createPath(self.mapView, sourceLocation: LocationHelper.standard.annotations[i - 1].coordinate, destinationLocation: LocationHelper.standard.annotations[i].coordinate)
                }
            }
        }
        presentPanModal(vc)
    }
    
    @objc func deleteButtonTapped() {
        LocationHelper.standard.removeAnnotations(mapView)
        mapView.removeOverlays(mapView.overlays)
    }
    
    @objc func createPathButtonTapped() {
        print(#function)
        LocationHelper.standard.checkNumberOfAnnotations()
        if LocationHelper.standard.isTrue {
            LocationHelper.standard.showRoutes(mapView, routes: LocationHelper.standard.routes)
            print(LocationHelper.standard.annotations)
            print(LocationHelper.standard.routes)
        }
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        view.addSubview(mapView)
        [searchButton, deleteButton, CreatePathButton].forEach { mapView.addSubview($0) }
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
        
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(mapView.snp.leading).inset(20)
            make.bottom.equalTo(mapView.snp.bottom).inset(20)
            make.height.width.equalTo(44)
        }
        
        CreatePathButton.snp.makeConstraints { make in
            make.leading.equalTo(mapView.snp.leading).inset(20)
            make.bottom.equalTo(deleteButton.snp.top).offset(-20)
            make.height.equalTo(44)
            make.width.equalTo(CreatePathButton.snp.height).multipliedBy(2)
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
            LocationHelper.standard.setRegion(mapView, center: LocationHelper.standard.location)
            LocationHelper.standard.setAnnotation(mapView, center: LocationHelper.standard.location)
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5
        renderer.strokeColor = .systemBlue
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        annotationView?.canShowCallout = true
        annotationView?.detailCalloutAccessoryView = Callout(annotation: annotation)
        return annotationView
    }
    
}
