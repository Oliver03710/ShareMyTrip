//
//  TouristAttractionsAPIManager.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/26.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

class TouristAttractionsAPIManager {
    
    static func requestTouristAttractions(pageNo: Int, completion: @escaping (TouristAttractions?, APIError?) -> Void) {
        
        guard let url = URL(string: "\(Endpoints.touristAttractionsURL)?serviceKey=\(APIKeys.touristAttractionsKey)&type=json&pageNo=\(pageNo)&numOfRows=10") else {
            print("Error")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                
                guard error == nil else {
                    print("Failed Request")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No Data Returned")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable Response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failed Response")
                    completion(nil, .failedRequest)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(TouristAttractions.self, from: data)
                    print(result)
                    completion(result, nil)
                } catch {
                    print(error)
                    completion(nil, .invalidData)
                }
                
            }
            
        }.resume()
        
    }
    
}
