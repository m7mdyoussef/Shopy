//
//  StripeClient.swift
//  Shopy
//
//  Created by mohamed youssef on 6/10/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class StripeClient {
    
    static let sharedClient = StripeClient()
    
    var baseURLString: String? = nil
    
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
//    func  createAndConfirmPayment(_ token: STPToken, amount: Int, completion: @escaping (_ error: Error?) -> Void){
////        let urlString = target.baseURL + target.endpoint
////        print("url is \(urlString)")
//      //  guard let url = URL(string: self.baseURL.appendingPathComponent("charge")) else {return}
//        let url = self.baseURL.appendingPathComponent("charge")
//
//
//        let params: [String : Any] = ["stripeToken" : token.tokenId, "amount" : amount, "description" : Constants.defaultDescriptionStripe, "currency" : Constants.defaultCurrencyStripe]
//
//        var request = URLRequest(url: url)
//        request.method = HTTPMethod.post
//        let session = URLSession.shared
//        request.httpShouldHandleCookies = false
////        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        request.addValue("application/json", forHTTPHeaderField: "Accept")
//       // request.httpBody = target.httpBody
//
//        session.dataTask(with: request) { (data, response, error) in
//            if let err = error{
//                print(err)
//                if (data?.count)! > 0 {print(error)}
//                completion(error)
//
//            }else{
//                if let data = data {
//                   // onSuccess(data)
//                    print("Payment successful")
//                    completion(nil)
//                }
//            }
//        }.resume()
//    }

    
    func createAndConfirmPayment(_ token: STPToken, amount: Int, completion: @escaping (_ error: Error?) -> Void) {

        let url = self.baseURL.appendingPathComponent("charge")

        let params: [String : Any] = ["stripeToken" : token.tokenId, "amount" : amount, "description" : Constants.defaultDescriptionStripe, "currency" : Constants.defaultCurrencyStripe]

        
        let serializer = DataResponseSerializer(emptyResponseCodes: Set([200, 204, 205]))
        
        AF.request(url, method: .post, parameters: params).validate().response(responseSerializer: serializer) { (response) in
        
//        AF.request(url, method: .post, parameters: params)
//            .validate(statusCode: 200..<300)
//            .responseData(completionHandler: { (response) in

                switch response.result {
                case .success( _):
                    print("Payment successful")
                    completion(nil)
                case .failure(let error):
                    if (response.data?.count)! > 0 {print(error)}
                    completion(error)
                }
            }
        //)
        
    }
}

