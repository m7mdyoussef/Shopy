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
    
    // amin
    case register(myCustomer: Customer)
    case allUsers
    case getOrders(financialState: FinancialStatus)
    // end amin
    
    case getProductElement(productId:String)
    case getPriceRule
    case getDiscountCode(priceRule: String)
    
    // MARK: joe
    case getMenCategoryProducts
    case getWomenCategoryProducts
    case getKidsCategoryProducts
    case getDetailedProducts
    //end
    
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
        //https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com/admin/api/2021-04/collections/268359598278/products.json
        
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
        case .getOrders(financialState: let state):
            return "/admin/api/2021-04/orders.json?financial_status=\(state.rawValue)"
            
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
        
        
        case .getProductElement(productId: let productId):
            return "/admin/api/2021-04/products/\(productId).json"
        case .getPriceRule:
            return "/admin/api/2021-04/price_rules.json"
        case .getDiscountCode(priceRule: let price_rule): //950502654150
            return "/admin/api/2021-04/price_rules/\(price_rule)/discount_codes.json"
            
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
        case .getOrders:
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
        
        case .getProductElement(productId: let productId):
            return .requestPlain
        case .getPriceRule:
            return .requestPlain
        case .getDiscountCode(priceRule: let price_rule):
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
