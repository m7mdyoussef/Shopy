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
   
}

class RemoteDataSource: ApiServices<RemoteDataSourceWrapper> , RemoteDataSourceProtocol {

    // MARK: joe
//    static let shared = RemoteDataSource()
//    private override init() {}
    // end
    
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
   
}
