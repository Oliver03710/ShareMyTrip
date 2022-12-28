//
//  SearchViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/02.
//

import UIKit
import CoreLocation

final class SearchViewModel {
    
    // MARK: - Properties
    
    var results: Observable<[SearchResults]> = Observable([])
    var searchText: Observable<String> = Observable("")
    var totalCounts: Observable<Int> = Observable(0)
    var pages: Observable<Int> = Observable(1)

    
    // MARK: - Helper Functions
    
    func reloadTableView(_ tableView: UITableView) {
        results.bind { results in
            tableView.reloadData()
            tableView.isHidden = results.isEmpty ? true : false
        }
    }
    
    func requestAPI(_ query: String, pages: Int) {
        
        SearchAPIManager.requestSearch(query: query, pages: pages) { data, error in
            
            guard let data = data else {
                print("Data 오류")
                return
            }
            
            self.totalCounts.value = data.meta.totalCount
            
            data.documents.forEach { result in
                
                guard let lat = result.latitude.toDouble(), let lon = result.longitude.toDouble() else {
                    print("Convert To Double Error")
                    return
                }

                let item = SearchResults(name: result.name, address: result.address, category: result.category, placeURL: result.placeURL, coordinates: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                
                let isContaining = self.results.value.contains(where: { result in
                    if result.placeURL == item.placeURL {
                        return true
                    } else {
                        return false
                    }
                })
                
                if isContaining {
                    
                } else {
                    self.results.value.append(item)
                }
                
                
            }
        }
    }
}
