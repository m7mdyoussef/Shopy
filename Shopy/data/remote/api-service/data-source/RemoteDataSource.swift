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
    func registerACustomer(customer:Customer, onCompletion: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void)
    func getAllUsers(onSuccess: @escaping (AllCustomers?)->Void , onError: @escaping (Error)->Void)

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

    func registerACustomer(customer:Customer, onCompletion: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void) {
        
        self.postACustomer(target: .register(myCustomer: customer)) { (data) in
            onCompletion(data)
        } onFailure: { (error) in
            onFailure(error)
        }


    }
    
    func getAllUsers(onSuccess: @escaping (AllCustomers?) -> Void, onError: @escaping (Error) -> Void) {
        self.fetchData(target: .allUsers, responseClass: AllCustomers.self) { (result) in
           
            switch result{
            case .success(let customer):
                onSuccess(customer)
            case .failure(let error):
                onError(error)
            }
        }
    }
}
