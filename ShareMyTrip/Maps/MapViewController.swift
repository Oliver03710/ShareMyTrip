//
//  MapViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/13.
//

import UIKit

class MapViewController: BaseViewController {

    // MARK: - Properties
    
    let mapView = MapView()
    
    
    // MARK: - Init
    
    override func loadView() {
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        
    }

}
