//
//  SearchAPIManager.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/02.
//

import Foundation

class SearchAPIManager {
    
    static func requestSearch(query: String, pages: Int, completion: @escaping (SearchData?, APIError?) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("검색어 오류")
            return
        }
        
        let urlString = "\(Endpoints.searchURL)?query=\(query)&page=\(pages)"

        guard  let url = URL(string: urlString) else {
            print("검색어 오류")
            return
        }
       
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(APIKeys.SearchKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
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
                    print("Failed Response: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchData.self, from: data)
                    print(result)
                    completion(result, nil)
                } catch {
                    print("error Data: \(error)")
                    completion(nil, .invalidData)
                }
                
            }
            
        }.resume()
        
    }
    
}
