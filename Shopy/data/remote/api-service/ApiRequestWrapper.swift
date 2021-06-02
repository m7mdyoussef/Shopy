//
//  ApiRequestWrapper.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 20/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import Alamofire

enum Endpoint{
    case staticEndpoint
    case dynamicEndPoint(path : String)
}
enum HttpMethod : String{
    case get    = "GET"
    case post   = "POST"
    case delete = "DELETE"
    case put    = "PUT"
    
}

enum Task {
    case requestPlain
//    case requestParameters(parameters :[String:String] , encoding : ParameterEncoding)
    case requestParameters(parameters :[String:Any] , encoding : ParameterEncoding)
}

protocol ApiRequestWrapper {
    var baseURL  : String           {get}
    var endpoint : String           {get}
    var task     : Task             {get}
    var headers  : [String:String]? {get}
    var httpMethod : HttpMethod     {get}
    var httpBody  : Data?         {get}
}
