//
//  ApiServices.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 20/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import Alamofire

class ApiServices<T : ApiRequestWrapper>{
    
    func fetchData<M :Codable>(target: T,responseClass : M.Type, completion:@escaping (Result<M?, NSError>) -> Void){
        guard AppCommon.shared.checkConnectivity() else {return}
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
        let method = Alamofire.HTTPMethod(rawValue: target.httpMethod.rawValue)
        
        
        
        AF.request(target.baseURL+target.endpoint, method: method, parameters: params.0, encoding:params.1, headers: headers).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else {
                // ADD Custom Error
                let error = NSError(domain: target.baseURL, code: 200, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
                completion(Result.failure(error))
                return
            }
            
            // print("\(response)")
            if statusCode == 200 { // 200 reflect success response
                // Successful request
                guard let jsonResponse = try? response.result.get() else {
                    // ADD Custom Error
                    let error = NSError(domain: target.baseURL, code: 200, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
                    completion(.failure(error))
                    return
                }
                
                // print("jsonResponse---->\(jsonResponse)")
                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    // ADD Custom Error
                    let error = NSError(domain: target.baseURL, code: 200, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
                    completion(.failure(error))
                    return
                }
                guard let responseObj = try? JSONDecoder().decode(M.self, from: theJSONData) else {
                    // ADD Custom Error
                    let error = NSError(domain: target.baseURL, code: 200, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
                    completion(.failure(error))
                    return
                }
                // print("responseObj---->\(responseObj)")
                    completion(Result.success(responseObj))
            } else {
                // ADD custom error base on status code 404 / 401 /
                // Error Parsing for the error message from the BE
                let message = "Error Message Parsed From backend"
                let error = NSError(domain: target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                completion(.failure(error))
            }
        }
        
    }
    func postACustomer(target:T,onSuccess: @escaping (Data)->Void , onFailure: @escaping (Error)->Void) {
        let urlString = target.baseURL + target.endpoint
        print("url is \(urlString)")
        guard let url = URL(string: urlString) else {return}
        guard AppCommon.shared.checkConnectivity() else {return}
        var request = URLRequest(url: url)
        request.method = HTTPMethod.post
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = target.httpBody
//        print("body \(try! request.httpBody?.asDictionary())")
        session.dataTask(with: request) { (data, response, error) in
            if let err = error{
                print(err)
                onFailure(err)
            }else{
                if let data = data {
                    onSuccess(data)
                }
            }
        }.resume()
    }
    
    
//    func createAndConfirmPayment(target:T,onSuccess: @escaping (Data)->Void , onFailure: @escaping (Error)->Void) {
//
//        let url = target.baseURL + target.endpoint
//            
//        
//        let params: [String : Any] = ["stripeToken" : token.tokenId, "amount" : amount, "description" : Constants.defaultDescriptionStripe, "currency" : Constants.defaultCurrencyStripe]
//
//        
//        let serializer = DataResponseSerializer(emptyResponseCodes: Set([200, 204, 205]))
//        
//        AF.request(url, method: .post, parameters: params).validate().response(responseSerializer: serializer) { (response) in
//        
////        AF.request(url, method: .post, parameters: params)
////            .validate(statusCode: 200..<300)
////            .responseData(completionHandler: { (response) in
//
//                switch response.result {
//                case .success( _):
//                    print("Payment successful")
//                    completion(nil)
//                case .failure(let error):
//                    if (response.data?.count)! > 0 {print(error)}
//                    completion(error)
//                }
//            }
//        //)
//        
//    }
    
    
    
}

private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
    switch task {
    case .requestPlain:
        return ([:], URLEncoding.default)
    case .requestParameters(parameters: let parameters, encoding: let encoding):
        return (parameters, encoding)
    }
}

