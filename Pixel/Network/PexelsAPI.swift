//
//  PexelsAPI.swift
//  Pixel
//
//  Created by Anna Zislina on 16/12/2019.
//  Copyright © 2019 Anna Zislina. All rights reserved.
//

import Foundation

class PexelsAPI {
    
    //MARK: API Key
    static let API_KEY = "563492ad6f917000010000013220e319baaa4faca30cd9ee99abf6cf"
    
    var photos: [Photo] = []
    
    //MARK: Endpoints
    enum Endpoints {
        
        static let baseURL = "http://api.pexels.com/v1"
        
        case search(String)
        
        var stringValue: String {
            switch self {
            case .search(let query):
               return Endpoints.baseURL + "/search" +  "?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&per_page=50&page=1"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    //MARK: GET Request
class func getRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
    
    var request = URLRequest(url: url)
        request.addValue(API_KEY, forHTTPHeaderField: "Authorization")
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil
            else {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
        let decoder = JSONDecoder()
        do {
            let responseObject = try decoder.decode(ResponseType.self, from: data)
            DispatchQueue.main.async {
                completion(responseObject, nil)
            }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    

    //MARK: Search func
class func search(query: String, completion: @escaping ([Photo], Error?) -> Void) -> URLSessionTask {
    
    let task = getRequest(url: Endpoints.search(query).url, responseType: PexelsResponse.self) { (response, error) in
        if let response = response {
            completion(response.photos, nil)
        }
        else {
            let errorDescription = error?.localizedDescription
            if errorDescription!.contains("The request timed out") {
                completion([], error)
            }
        }
    }
    task.resume()
    return task
    }
}
