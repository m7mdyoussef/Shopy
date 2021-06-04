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
    
    // MARK: joe
    case getMenCategoryProducts
    case getWomenCategoryProducts
    case getKidsCategoryProducts
    case getDetailedProducts
    //end
    
}

extension RemoteDataSourceWrapper :ApiRequestWrapper{
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    
    var baseURL: String {
        return  "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com"
      //https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com/admin/api/2021-04/collections/268359598278/products.json
        
    }
    
    var endpoint: String {
        switch self {
        case .getAllCustomCollections:
            return "/admin/api/2021-04/custom_collections.json"
        case .getAllproducts(collectionId: let collectionId):
          return "/admin/api/2021-04/collections/\(collectionId)/products.json"
           
            // MARK: joe
            case .getMenCategoryProducts:
                return Constants.menCatPath
            case .getWomenCategoryProducts:
                return Constants.womenCatPath
            case .getKidsCategoryProducts:
                return Constants.kidCatPath
            case .getDetailedProducts:
                return Constants.DetailedProductsPath
            //end
        }
        
    }
    var task: Task {
        switch self {
        case .getAllCustomCollections:
            return .requestPlain
        case .getAllproducts(collectionId: let collectionId):
            return .requestPlain
            
            // MARK: joe
            case .getMenCategoryProducts:
                return .requestPlain
            case .getWomenCategoryProducts:
                return .requestPlain
            case .getKidsCategoryProducts:
                return .requestPlain
            case .getDetailedProducts:
                 return .requestPlain
            
            //end
        }
        
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}