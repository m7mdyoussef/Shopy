//
//  Product.swift
//  Shopy
//
//  Created by SOHA on 6/1/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

// MARK: - Product
struct Product: Codable {
    let product: ProductClass
}

// MARK: - ProductClass
struct ProductClass: Codable {
    let id: Int
    let title, bodyHTML, vendor, productType: String
    let createdAt: String
    let handle: String
    let updatedAt, publishedAt: String
    let status, publishedScope, tags, adminGraphqlAPIID: String
    let variants: [Variant]
    let options: [Option]
    let images: [ImageProduct]
    let image: ImageProduct

    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case status
        case publishedScope = "published_scope"
        case tags
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case variants, options, images, image
    }
}

// MARK: - Image
struct ImageProduct: Codable {
    let id, productID, position: Int
    let createdAt, updatedAt: String
    let width, height: Int
    let src: String
    let adminGraphqlAPIID: String
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case  width, height, src
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}

// MARK: - Option
struct Option: Codable {
    let id, productID: Int
    let name: String
    let position: Int
    let values: [String]
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}

// MARK: - Variant
struct Variant: Codable {
    let id, productID: Int
    let title, price, sku: String
    let position: Int
    let inventoryPolicy: String
    let fulfillmentService: String
    let inventoryManagement: String
    let option1: String
    let option2: String
    let createdAt, updatedAt: String
    let taxable: Bool
    let grams: Int
    let weight: Int
    let weightUnit: String
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int
    let requiresShipping: Bool
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, sku, position
        case inventoryPolicy = "inventory_policy"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case option1, option2
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable, grams
        case weight
        case weightUnit = "weight_unit"
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case requiresShipping = "requires_shipping"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}

