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
    let order: PostOrder
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
