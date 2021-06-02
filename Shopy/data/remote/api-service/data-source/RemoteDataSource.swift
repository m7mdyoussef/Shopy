//
//  RemoteDataSource.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 24/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

protocol RemoteDataSourceProtocol {
    
    func customCollections(completion: @escaping (Result<CustomCollection?, NSError>) -> Void)
    func getProducts(collectionId:String, completion: @escaping (Result<Product?, NSError>) -> Void)
    func registerACustomer(customer:Customer, completion: @escaping (Any) -> Void)
}

class RemoteDataSource: ApiServices<RemoteDataSourceWrapper> , RemoteDataSourceProtocol {
    
    func customCollections(completion: @escaping (Result<CustomCollection?, NSError>) -> Void) {
        
        self.fetchData(target: .getAllCustomCollections, responseClass: CustomCollection.self) { (result) in
            completion(result)
        }
     }
    
    func getProducts(collectionId:String, completion: @escaping (Result<Product?, NSError>) -> Void) {
        self.fetchData(target: .getAllproducts(collectionId: collectionId), responseClass: Product.self){(result) in
            completion(result)
        }
    }

    func registerACustomer(customer:Customer, completion: @escaping (Any) -> Void) {

        self.registerCustomer(target: .registerACustomer(myCustomer: customer)) { (json) in
            completion(json)
        } onFailure: { (error) in
            completion(error)
        }

    }
}
