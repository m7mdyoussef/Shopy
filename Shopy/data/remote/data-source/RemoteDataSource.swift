//
//  RemoteDataSource.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 24/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

protocol RemoteDataSourceProtocol {
    func customCollections(completion: @escaping (Result<CustomCollectionResponse<CustomCollection>?, NSError>) -> Void)
}

class RemoteDataSource: ApiServices<RemoteDataSourceWrapper> , RemoteDataSourceProtocol {
    func customCollections(completion: @escaping (Result<CustomCollectionResponse<CustomCollection>?, NSError>) -> Void) {
        self.fetchData(target: .getAllCustomCollections, responseClass: CustomCollectionResponse<CustomCollection>.self) { (result) in
            completion(result)
        }
     }
}
