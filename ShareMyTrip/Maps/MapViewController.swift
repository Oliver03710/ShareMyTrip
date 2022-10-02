//
//  MapViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit
import MapKit
import CoreLocation

import RealmSwift
import SnapKit
import PanModal

protocol TransferMapViewDelegate: AnyObject {
    func passMapView(_ mapView: MKMapView)
}

final class MapViewController: BaseViewController {
    
    // MARK: - Properties
    
    lazy var mapView: MKMapView = {
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
    
    private lazy var deleteButton: CircleButton = {
        let btn = CircleButton(backgroundColor: .red, titleOrImage: "trash", hasTitle: false, componentColor: .white, addTarget: self, action: #selector(deleteButtonTapped))
        return btn
    }()
    
    lazy var finishTripButton: BaseButton = {
        let btn = BaseButton(backgroundColor: .systemBrown, titleOrImage: "여행종료", hasTitle: true, componentColor: .white, addTarget: self, action: #selector(finishTripButtonTapped))
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    private let viewModel = MapViewModel()
    weak var delegate: TransferMapViewDelegate?
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Selectors
    
    @objc private func searchButtonTapped() {
        viewModel.searchButtonTapped(mapView, vcs: self)
    }
    
    @objc private func deleteButtonTapped() {
        viewModel.deleteButtonClicked(mapView, vc: self)
    }
    
    @objc private func createPathButtonTapped() {
        viewModel.createPathButtonTapped(mapView)
    }
    
    @objc private func finishTripButtonTapped() {
        viewModel.finishTripButtonTapped(mapView, vc: self)
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        setNaviButtons()
        print("Realm is located at:", TripHistoryRepository.standard.localRealm.configuration.fileURL!)
        
        TouristAttractionsRepository.standard.fetchRealmData()
        TripHistoryRepository.standard.fetchRealmData()
        if TripHistoryRepository.standard.fetchCurrentTrip().isEmpty {
            TripHistoryRepository.standard.addItem(tripName: "", trips: [], companions: [])
        }
        LocationHelper.standard.loadAnnotations(mapView, index: nil, status: .current)
        delegate?.passMapView(self.mapView)
    }
    
    override func setContraints() {
        view.addSubview(mapView)
        [deleteButton, finishTripButton].forEach { mapView.addSubview($0) }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(mapView.snp.leading).inset(20)
            make.bottom.equalTo(mapView.snp.bottom).inset(20)
            make.height.width.equalTo(44)
        }
        
        finishTripButton.snp.makeConstraints { make in
            make.trailing.equalTo(mapView.snp.trailing).inset(20)
            make.bottom.equalTo(mapView.snp.bottom).inset(20)
            make.height.equalTo(44)
            make.width.equalTo(finishTripButton.snp.height).multipliedBy(2)
        }
        
    }
    
    private func setNaviButtons() {
        let searchBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        let routeBarButton = UIBarButtonItem(title: "경로보기", style: .plain, target: self, action: #selector(createPathButtonTapped))
        navigationItem.leftBarButtonItem = routeBarButton
        navigationItem.rightBarButtonItem = searchBarButton
        navigationController?.navigationBar.tintColor = .systemBrown
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
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        renderer.setColors([UIColor(red: 0.02, green: 0.91, blue: 0.05, alpha: 1),
                            UIColor(red: 1, green: 0.48, blue: 0, alpha: 1),
                            UIColor(red: 1, green: 0, blue: 0, alpha: 1)], locations: [])
        renderer.lineWidth = 5
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
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        
        viewModel.isExecutedFunc(identifier: annotation.identifier, taskOrder: currentTrip[0].trips.count - 1, annotationView: annotationView, annotation: annotation)

        return annotationView
    }
    
}


// MARK: - Extension: PanModalPresentable

extension MapViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeightIgnoringSafeArea(0)
    }

    var longFormHeight: PanModalHeight {
        return shortFormHeight
    }

    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.1)
    }

    var shouldRoundTopCorners: Bool {
        return false
    }

    var showDragIndicator: Bool {
        return true
    }

    var anchorModalToLongForm: Bool {
        return false
    }

    var isUserInteractionEnabled: Bool {
        return true
    }
    
}
