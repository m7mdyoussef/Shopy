
//
//  productsModel.swift
//  Shopy
//
//  Created by mohamed youssef on 6/1/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

// MARK: - ProductModel
struct ProductModel: Codable {
    let products: [CategoryProduct]
}

// MARK: - Product
struct CategoryProduct: Codable {
    let id: Int
    let title, bodyHTML, vendor, productType: String
    let createdAt: String
    let handle: String
    let updatedAt, publishedAt: String
    let publishedScope, tags, adminGraphqlAPIID: String
    let options: [ProductOption]
    let images: [ProductImage]
    let image: ProductImage

    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case publishedScope = "published_scope"
        case tags
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case options, images, image
    }
}

// MARK: - Image
struct ProductImage: Codable {
    let id, productID, position: Int
    let createdAt, updatedAt: String
    let width, height: Int
    let src: String
    let variantIDS: [Int]
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, src
        case variantIDS = "variant_ids"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}

// MARK: - Option
struct ProductOption: Codable {
    let id, productID: Int
    let name: String
    let position: Int

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position
    }
}
