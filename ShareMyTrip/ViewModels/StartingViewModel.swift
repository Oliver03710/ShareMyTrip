//
//  StartingViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/20.
//

import UIKit

final class StartingViewModel {
    
    // MARK: - Helper Functions
    
    func TransitionAfterRequestAPI() {
        
        let group = DispatchGroup()
        
        TouristAttractionsRepository.standard.fetchRealmData()
        if TouristAttractionsRepository.standard.tasks.isEmpty {
            group.enter()
            TouristAttractionsAPIManager.requestTouristAttractions(pageNo: 1) { data, error in
                if let data = data {
                    for i in data.response.body.items {
                        guard let lat = Double(i.latitude), let lon = Double(i.longitude) else { return }
                        TouristAttractionsRepository.standard.addItem(name: i.name, address: i.address, introduction: i.introduction, admin: i.admin, phoneNumber: i.phoneNumber, latitude: lat, longitude: lon)
                    }
                }
                group.leave()
            }
            
        }
        
        group.notify(queue: .main) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let vc = MainTapBarController()
            
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
        }
        
    }
    
}
