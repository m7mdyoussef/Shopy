//
//  RemoteDataSource.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 24/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation




protocol RemoteDataSourceProtocol {
    
    //amin
    func customCollections(completion: @escaping (Result<CustomCollection?, NSError>) -> Void)
    func registerACustomer(customer:Customer, onCompletion: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void)
    func getAllUsers(onSuccess: @escaping (AllCustomers?)->Void , onError: @escaping (Error)->Void)
    func getCustomer(customerId : Int,onCompletion: @escaping (Customer?) -> Void)
    func fetchOrders( completion: @escaping (Result<Orders?,NSError>) -> Void )
    func postOrder(order:PostOrderRequest , onCompletion: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void)
    func updateCustomer(customer:Customer,id:Int,onCompletion:@escaping (Data) -> Void,onFalure: @escaping (Error)->Void)
    //end amin
    
    
    // MARK: joe
    func getCategoryProducts(categoryType:String,completion: @escaping (Result<Products?,NSError>) -> Void)
    func getDetailedProducts(completion: @escaping (Result<DetailedProductsModel?, NSError>) -> Void)
    func getProducts(collectionId:String, completion: @escaping (Result<Products?, NSError>) -> Void)
    func getProductElement(productId:String, completion: @escaping (Result<Product?, NSError>) -> Void)
    //end
    
}

class RemoteDataSource: ApiServices<RemoteDataSourceWrapper> , RemoteDataSourceProtocol {
//    var apiServices:ApiServices<ApiRequestWrapper>!
//    init(api:ApiServices) {
//        api = apiServices
//    }
    
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
    
    // amin
    func registerACustomer(customer:Customer, onCompletion: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void) {
        self.postData(target: .register(myCustomer: customer), onSuccess: { (data) in
            onCompletion(data)
        }) { (error) in
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
    
    func fetchOrders( completion: @escaping (Result<Orders?, NSError>) -> Void) {
        self.fetchData(target: .getOrders, responseClass: Orders.self) { (result) in
            completion(result)
        }
    }
    
    
    func postOrder(order:PostOrderRequest , onCompletion: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void) {
        self.postData(target: .postOrder(order: order), onSuccess: { (data) in
//        print(String(decoding: data, as: UTF8.self))
            onCompletion(data)
        }) { (error) in
            onFailure(error)
        }
    }
    
    func removeOrder(id:Int) {
        self.fetchData(target: .removeOrder(id: id), responseClass: RemoveOrderResponse.self) { (result) in
            switch result{
            case .success(let response):
                print("(success \(String(describing: response))")
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func updateCustomer(customer: Customer, id: Int, onCompletion: @escaping (Data) -> Void, onFalure: @escaping (Error) -> Void) {
        
        self.postData(target: .updateCustomer(customer: customer, id: id), onSuccess: { (data) in
            onCompletion(data)
        }) { (err) in
             onFalure(err)
        }
        

    }
    
    func getCustomer(customerId: Int, onCompletion: @escaping (Customer?) -> Void) {
        fetchData(target: .getCustomer(customerId: customerId), responseClass: Customer.self) { (result) in
            switch result{
            case .success(let customer):
                onCompletion(customer)
            case .failure(let err):
                print(err)
                onCompletion(nil)
            }
        }
    }
    
    
    // end amin
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
