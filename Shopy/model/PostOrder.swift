//
//  PostOrder.swift
//  Shopy
//
//  Created by Amin on 10/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

// MARK: - discount_codePostOrder
struct PostOrderRequest: Codable {
    let order: PostNewOrder
}

// MARK: - discount_codeOrder
struct PostOrder: Codable {
    let email, fulfillmentStatus: String
    let lineItems: [PostLineItem]
    enum CodingKeys: String, CodingKey {
        case email
        case fulfillmentStatus = "fulfillment_status"
        case lineItems = "line_items"
    }
}
// new
struct PostNewOrder:Codable {
    let lineItems: [PostLineItem]
    let customer: MyCustomer
    let financialStatus: String
    let discountCode: [Code]
    
    enum CodingKeys: String, CodingKey {
        case lineItems = "line_items"
        case customer
        case financialStatus = "financial_status"
        case discountCode = "discount_codes"
    }
}

//struct Codes:Codable {
//    let codes : [Code]
//}

struct Code:Codable {
    
    let code : String
    var ammount : String = "10.00"
    var type : String = "percentage"
    
    enum CodingKeys: String, CodingKey {
        case code
        case ammount = "amount"
        case type
    }

}

struct MyCustomer: Codable {
    let id: Int
}

//new

struct PostCustomer: Codable {
    let id: Int
}

// MARK: - discount_codeLineItem
struct PostLineItem: Codable {
    let variantID, quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case variantID = "variant_id"
        case quantity
    }
}
