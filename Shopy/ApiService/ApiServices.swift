//
//  ApiServices.swift
//  Shopy
//
//  Created by mohamed youssef on 5/20/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import Alamofire

class ApiServices{
    
    // singletone
    static let instance = ApiServices()
    
    
    func getResponses<T: Decodable>(url: String, id: String = "" ,completion: @escaping(T?, Error?) ->Void){
        let parameters: Parameters = ["id": Int(id) ?? "", "s": id]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            guard let responseData = response.data else{
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let data = try decoder.decode(T.self, from: responseData)
            
                completion(data, nil)

            }catch{
                print("onFailure")
                completion(nil, error)
            }
        }
    }
}

