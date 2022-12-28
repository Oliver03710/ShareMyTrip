//
//  RecommendationsViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/02.
//

import Foundation
import MapKit

final class RecommendationsViewModel {
    
    // MARK: - Properties
    
    var touristAttractionsAnno: Observable<[TouristAttractions]> = Observable([])

    
    // MARK: - Helper Functions
    
    func regionContainsAnno(index: Int) {
        let currentTrip = TripHistoryRepository.standard.fetchTrips(.current)
        touristAttractionsAnno.value.removeAll()
        let center = CLLocationCoordinate2D(latitude: currentTrip[0].trips[index].latitude, longitude: currentTrip[0].trips[index].longitude)
        
        for i in TouristAttractionsRepository.standard.tasks {
            let region = CLCircularRegion(center: center, radius: 10000, identifier: "\(currentTrip[0].trips[index].turn)")
            let isContained = region.contains(CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude))
            
            if isContained {
                touristAttractionsAnno.value.append(i)
            }
        }
    }
    
}
