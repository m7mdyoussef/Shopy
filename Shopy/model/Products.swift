//
//  Product.swift
//  Shopy
//
//  Created by SOHA on 5/31/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
// MARK: - Product
struct Products: Codable {
    let products: [ProductElement]
}

// MARK: - ProductElement
struct ProductElement: Codable {
    let id: Int
    let title, bodyHTML, vendor, productType: String
    let createdAt: String
    let handle: String
    let updatedAt, publishedAt: String
    let publishedScope, tags, adminGraphqlAPIID: String
    let options: [OptionProducts]
    let images: [ImagesProducts]
    let image: ImagesProducts

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

// MARK: - Images
struct ImagesProducts: Codable {
    let id, productID, position: Int
    let createdAt, updatedAt: String
    let alt: String?
    let width, height: Double
    let src: String
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case alt, width, height, src
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}

// MARK: - Option
struct OptionProducts: Codable {
    let id, productID: Int
    let name: String
    let position: Int

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position
    }
}
