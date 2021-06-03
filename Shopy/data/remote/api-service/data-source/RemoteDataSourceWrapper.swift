//
//  RemoteDataSourceWrapper.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 20/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import Alamofire

enum RemoteDataSourceWrapper{
    case getAllCustomCollections
    case getAllproducts(collectionId : String)
    case register(myCustomer: Customer)
    case allUsers
}

extension RemoteDataSourceWrapper :ApiRequestWrapper{
    
    var httpMethod: HttpMethod {
        //        return .get
        
        switch self {
        case .register(myCustomer: _):
            return .post
        default:
            return .get
        }
    }
    
    var httpBody:Data?{
        switch self {
        case .register(myCustomer: let customer):
            var jsonData:Data = Data()
            do {
                jsonData = try JSONSerialization.data(withJSONObject: customer.asDictionary(), options: .prettyPrinted)
                return jsonData
                print("json data is \(jsonData)")
            } catch let error {
                print(error.localizedDescription)
            }
            return nil
        default:
            return nil
        }
    }
    
    var baseURL: String {
        return  "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com"
    }
    
    var endpoint: String {
        switch self {
        case .getAllCustomCollections:
            return "/admin/api/2021-04/custom_collections.json"
        case .getAllproducts(collectionId: let collectionId):
            return "/admin/api/2021-04/collections/\(collectionId)/products.json"
        case .register:
            return "/admin/api/2021-04/customers.json"
        case .allUsers:
            return "/admin/api/2021-04/customers.json"
        }
        
    }
    var task: Task {
        
        switch self {
        case .getAllCustomCollections:
            return .requestPlain
        case .getAllproducts:
            return .requestPlain
        case .register:
            return .requestPlain
        case .allUsers:
        return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        case .register:
            return ["Content-Type":"application/json"]
        default:
            return nil
        }
    }
    
    
}
