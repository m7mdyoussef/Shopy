//
//  MockCategory.swift
//  ShopyTests
//
//  Created by mohamed youssef on 6/17/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
@testable import Shopy

class MockCategory: RemoteDataSourceProtocol {
    var shouldReturnError:Bool!
    
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    var error:Error!
      var productsJSONResponse : [String:[[String:Any]]] =
 [
    "products": [
        [
            "id": 6687367823558,
            "title": "ADIDAS | CLASSIC BACKPACK",
            "body_html": "This women's backpack has a glam look, thanks to a faux-leather build with an allover fur print. The front zip pocket keeps small things within reach, while an interior divider reins in potential chaos.",
            "vendor": "ADIDAS",
            "product_type": "ACCESSORIES",
            "created_at": "2021-05-17T23:50:25+02:00",
            "handle": "adidas-classic-backpack",
            "updated_at": "2021-06-17T22:31:26+02:00",
            "published_at": "2021-05-17T23:50:25+02:00",
            "template_suffix": "null",
            "status": "active",
            "published_scope": "web",
            "tags": "adidas, backpack, egnition-sample-data",
            "admin_graphql_api_id": "gid://shopify/Product/6687367823558",
            "variants": [
                [
                    "id": 39853312540870,
                    "product_id": 6687367823558,
                    "title": "OS / black",
                    "price": "70.00",
                    "sku": "AD-03-black-OS",
                    "position": 1,
                    "inventory_policy": "deny",
                    "compare_at_price": "null",
                    "fulfillment_service": "manual",
                    "inventory_management": "shopify",
                    "option1": "OS",
                    "option2": "black",
                    "option3": "null",
                    "created_at": "2021-05-17T23:50:26+02:00",
                    "updated_at": "2021-05-17T23:51:26+02:00",
                    "taxable": true,
                    "barcode": "null",
                    "grams": 0,
                    "image_id": "null",
                    "weight": 0.0,
                    "weight_unit": "kg",
                    "inventory_item_id": 41947933147334,
                    "inventory_quantity": 16,
                    "old_inventory_quantity": 16,
                    "requires_shipping": true,
                    "admin_graphql_api_id": "gid://shopify/ProductVariant/39853312540870"
                ]
            ],
            "options": [
                [
                    "id": 8585099313350,
                    "product_id": 6687367823558,
                    "name": "Size",
                    "position": 1,
                    "values": [
                        "OS"
                    ]
                ],
                [
                    "id": 8585099346118,
                    "product_id": 6687367823558,
                    "name": "Color",
                    "position": 2,
                    "values": [
                        "black"
                    ]
                ]
            ],
            "images": [
                [
                    "id": 29002678730950,
                    "product_id": 6687367823558,
                    "position": 1,
                    "created_at": "2021-05-17T23:50:26+02:00",
                    "updated_at": "2021-05-17T23:50:26+02:00",
                    "alt": "null",
                    "width": 635,
                    "height": 560,
                    "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/85cc58608bf138a50036bcfe86a3a362.jpg?v=1621288226",
                    "variant_ids": [],
                    "admin_graphql_api_id": "gid://shopify/ProductImage/29002678730950"
                ],
                [
                    "id": 29002678763718,
                    "product_id": 6687367823558,
                    "position": 2,
                    "created_at": "2021-05-17T23:50:26+02:00",
                    "updated_at": "2021-05-17T23:50:26+02:00",
                    "alt": "null",
                    "width": 635,
                    "height": 560,
                    "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/8a029d2035bfb80e473361dfc08449be.jpg?v=1621288226",
                    "variant_ids": [],
                    "admin_graphql_api_id": "gid://shopify/ProductImage/29002678763718"
                ],
                [
                    "id": 29002678796486,
                    "product_id": 6687367823558,
                    "position": 3,
                    "created_at": "2021-05-17T23:50:26+02:00",
                    "updated_at": "2021-05-17T23:50:26+02:00",
                    "alt": "null",
                    "width": 635,
                    "height": 560,
                    "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/ad50775123e20f3d1af2bd07046b777d.jpg?v=1621288226",
                    "variant_ids": [],
                    "admin_graphql_api_id": "gid://shopify/ProductImage/29002678796486"
                ]
            ],
            "image": [
                "id": 29002678730950,
                "product_id": 6687367823558,
                "position": 1,
                "created_at": "2021-05-17T23:50:26+02:00",
                "updated_at": "2021-05-17T23:50:26+02:00",
                "alt": "null",
                "width": 635,
                "height": 560,
                "src": "https://cdn.shopify.com/s/files/1/0567/9310/4582/products/85cc58608bf138a50036bcfe86a3a362.jpg?v=1621288226",
                "variant_ids": [],
                "admin_graphql_api_id": "gid://shopify/ProductImage/29002678730950"
            ]
        ],
    ]
    ]

    
    
    enum ErrorHandler : Error {
        case returnError
    }
    
    
    
    
    func getDetailedProducts(completion: @escaping (Result<DetailedProductsModel?, NSError>) -> Void) {
         var products:DetailedProductsModel
                   do{
                       let jsonData = try JSONSerialization.data(withJSONObject: productsJSONResponse, options: .fragmentsAllowed)
                        products = try JSONDecoder().decode(DetailedProductsModel.self, from: jsonData)
                       
                       if shouldReturnError{
                          completion(.failure(error! as NSError))
                       }else{
                          completion(.success(products))
                       }

                   }catch let error{
                       print(error.localizedDescription)
                   }
     }
    
    
  func getCategoryProducts(categoryType: String, completion: @escaping (Result<Products?, NSError>) -> Void) {
 
   }
    
    func customCollections(completion: @escaping (Result<CustomCollection?, NSError>) -> Void) {
        
    }
    
    func registerACustomer(customer: Customer, onCompletion: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void) {
        
    }
    
    func getAllUsers(onSuccess: @escaping (AllCustomers?) -> Void, onError: @escaping (Error) -> Void) {
        
    }
    
    func getCustomer(customerId: Int, onCompletion: @escaping (Customer?) -> Void) {
        
    }
    
    func fetchOrders(completion: @escaping (Result<Orders?, NSError>) -> Void) {
        
    }
    
    func postOrder(order: PostOrderRequest, onCompletion: @escaping (Data) -> Void, onFailure: @escaping (Error) -> Void) {
        
    }
    
    func updateCustomer(customer: Customer, id: Int, onCompletion: @escaping (Data) -> Void, onFalure: @escaping (Error) -> Void) {
        
    }
    
    
 
    
    func getProducts(collectionId: String, completion: @escaping (Result<Products?, NSError>) -> Void) {
        
    }
    
    func getProductElement(productId: String, completion: @escaping (Result<Product?, NSError>) -> Void) {
        
    }
     }
