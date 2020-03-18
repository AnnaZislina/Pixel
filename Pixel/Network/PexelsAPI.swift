//
//  PexelsAPI.swift
//  Pixel
//
//  Created by Anna Zislina on 16/12/2019.
//  Copyright © 2019 Anna Zislina. All rights reserved.
//

import Foundation
import CoreData

class PexelsAPI {
    
    var dataController: DataController!
    //var photos: [Photo] = []
    var photos: [PhotoModel] = []
    
    static let API_KEY = "563492ad6f917000010000013220e319baaa4faca30cd9ee99abf6cf"
    
    enum Endpoints {
        static let baseURL = "http://api.pexels.com/v1"
        
        case search(String)
        
        var stringValue: String {
            switch self {
            case .search(let query):
               return Endpoints.baseURL + "/search" +  "?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&per_page=15&page=1"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }

//    func parseResponse(forData jsonData: Data) {
//        do {
//            guard let codableContext = CodingUserInfoKey.init(rawValue: "context") else { fatalError("Failed context")}
//            let managedObjContext = dataController.viewContext
//            let decoder = JSONDecoder()
//            decoder.userInfo[codableContext] = managedObjContext
//            _ = try decoder.decode([Photo].self, from: jsonData)
//            try managedObjContext.save()
//            self.fetchData()
//        } catch {
//            print("Error ->\(error.localizedDescription)")
//        }
//    }
    
//    func fetchData() {
//        let managedObjContext = dataController.viewContext
//        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
//        do {
//            self.photos = try managedObjContext.fetch(fetchRequest)
//        } catch let error {
//            print(error)
//        }
//    }
    
//    func get(url: URL) {
//        var request = URLRequest(url: url)
//        request.addValue(PexelsAPI.API_KEY, forHTTPHeaderField: "Authorization")
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let jsonData = data else { return }
//            DispatchQueue.main.async {
//                self.parseResponse(forData: jsonData)
//            }
//        }
//        task.resume()
//    }
    
    //MARK: GET REQUEST
   class func getRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.addValue(API_KEY, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
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
        return task //wasted network calls
    }
    

    //MARK: SEARCH FUNC
   class func search(query: String, completion: @escaping ([PhotoModel], Error?) -> Void) -> URLSessionTask {
        
    let task = getRequest(url: Endpoints.search(query).url, responseType: PexelsResponse.self) { (response, error) in
            if let response = response {
                completion(response.photos, nil)
            } else {
                completion([], error)
            }
        }
        task.resume()
        return task
    }
}
