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
    
}

extension RemoteDataSourceWrapper :ApiRequestWrapper{
    
    var baseURL: String {
        return  "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com"
    }
    var endpoint: String {
        switch self {
        case .getAllCustomCollections:
            return "/admin/api/2021-04/custom_collections.json"
            
        }
        
    }
    var task: Task {
        switch self {
        case .getAllCustomCollections:
            return .requestPlain
        }
        
    }
    var headers: [String : String]? {
        return nil
    }
    
    
}
