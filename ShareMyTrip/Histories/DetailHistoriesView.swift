//
//  DetailHistoriesView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/23.
//

import UIKit
import MapKit

import SnapKit

final class DetailHistoriesView: BaseView {

    // MARK: - Properties
    
    lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .insetGrouped, cellClass: CompanionsTableViewCell.self, forCellReuseIdentifier: CompanionsTableViewCell.reuseIdentifier, delegate: self)
        tv.backgroundColor = .white
        return tv
    }()
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        return mv
    }()
    
    var index = 0
    let viewModel = DetailHistoriesViewModel()
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        TripHistoryRepository.standard.fetchRealmData()
    }
    
    override func setConstraints() {
        [mapView, tableView].forEach { self.addSubview($0) }
        
        mapView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self.snp.width).multipliedBy(1.2)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
}


// MARK: - Extension: UITableViewDelegate

extension DetailHistoriesView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.settingView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension DetailHistoriesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TripHistoryRepository.standard.tasks[index].companions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanionsTableViewCell.reuseIdentifier, for: indexPath) as? CompanionsTableViewCell else { return UITableViewCell() }
        
        cell.nameLabel.text = TripHistoryRepository.standard.tasks[index].companions[indexPath.row].companion
        
        return cell
    }
    
}


// MARK: - Extension: MKMapViewDelegate

extension DetailHistoriesView: MKMapViewDelegate {
    
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
        
        let tripHistory = TripHistoryRepository.standard.fetchTripHistory()
        print("trip history count: \(tripHistory.count)")
        print("trip history last one count: \(tripHistory[index].trips.count)")
        viewModel.showCustomAnno(identifier: annotation.identifier, taskOrder: tripHistory[index].trips.count - 1, annotationView: annotationView, annotation: annotation, index: index)

        return annotationView
    }
    
}
