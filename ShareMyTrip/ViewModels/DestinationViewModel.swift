//
//  DestinationViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/27.
//

import Foundation
import MapKit

import RealmSwift

final class DestinationViewModel {
    
    var touristAttractionsAnno: Observable<[TouristAttractions]> = Observable([])
    
    func regionContainsAnno(index: Int) {
        let currentTrip = TripHistoryRepository.standard.fetchCurrentTrip()
        touristAttractionsAnno.value.removeAll()
        let center = CLLocationCoordinate2D(latitude: currentTrip[0].trips[index].latitude, longitude: currentTrip[0].trips[index].longitude)
        
        for i in TouristAttractionsRepository.standard.tasks {
            let region = CLCircularRegion(center: center, radius: 10000, identifier: "\(currentTrip[0].trips[index].turn)")
            let isContained = region.contains(CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude))
            
            if isContained {
                // 배열에 담아서 리스트에 보여주기
                touristAttractionsAnno.value.append(i)
                
            }
        }
        
    }
    
}
