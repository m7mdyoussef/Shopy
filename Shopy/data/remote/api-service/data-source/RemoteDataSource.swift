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

   // func getProducts(collectionId:String, completion: @escaping (Result<Product?, NSError>) -> Void)
    
    // MARK: joe
        func getCategoryProducts(categoryType:String,completion: @escaping (Result<Products?,NSError>) -> Void)
    func getDetailedProducts(completion: @escaping (Result<DetailedProductsModel?, NSError>) -> Void)

    //end

    func getProducts(collectionId:String, completion: @escaping (Result<Products?, NSError>) -> Void)
    func getProductElement(productId:String, completion: @escaping (Result<Product?, NSError>) -> Void)

}

class RemoteDataSource: ApiServices<RemoteDataSourceWrapper> , RemoteDataSourceProtocol {


    
    func customCollections(completion: @escaping (Result<CustomCollection?, NSError>) -> Void) {
        
        self.fetchData(target: .getAllCustomCollections, responseClass: CustomCollection.self) { (result) in
            completion(result)
        }
     }
    
    func getProducts(collectionId:String, completion: @escaping (Result<Products?, NSError>) -> Void) {
        self.fetchData(target: .getAllproducts(collectionId: collectionId), responseClass: Products.self){(result) in
            completion(result)
        }
    }
    
    func getProductElement(productId: String, completion: @escaping (Result<Product?, NSError>) -> Void) {
        self.fetchData(target: .getProductElement(productId: productId), responseClass: Product.self){ (result) in
            completion(result)
        }
    }
    
    func getPriceRules(completion: @escaping (Result<PriceRules?, NSError>) -> Void) {
    
    self.fetchData(target: .getPriceRule, responseClass: PriceRules.self) { (result) in
        completion(result)
    }
 }
    
    func getDiscountCode(priceRule: String, completion: @escaping (Result<DiscountCode?, NSError>) -> Void) {
        self.fetchData(target: .getDiscountCode(priceRule: priceRule), responseClass: DiscountCode.self){ (result) in
            completion(result)
        }
    }
    
     // MARK: joe
    func getCategoryProducts(categoryType: String, completion: @escaping (Result<Products?, NSError>) -> Void) {
        var targetType:RemoteDataSourceWrapper = .getMenCategoryProducts
        if(categoryType == "Men"){  //men
            targetType = .getMenCategoryProducts
        }else if(categoryType == "Women"){
            targetType = .getWomenCategoryProducts
        }else{
            targetType = .getKidsCategoryProducts
        }
        
        self.fetchData(target: targetType, responseClass: Products.self) { (result) in
            completion(result)
        }
    }
    
    func getDetailedProducts(completion: @escaping (Result<DetailedProductsModel?, NSError>) -> Void) {
        self.fetchData(target: .getDetailedProducts, responseClass: DetailedProductsModel.self) { (result) in
            completion(result)
        }
    }
    
    //end
}
