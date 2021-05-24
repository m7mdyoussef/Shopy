//
//  CustomCollection.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 24/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

struct CustomCollectionResponse<T : Codable>: Codable {
    var customCollections:[T]?
    enum CodingKeys : String , CodingKey{
        case customCollections = "custom_collections"
        
    }
}

// MARK: - CustomCollection
struct CustomCollection: Codable {
    let id: Int
    let handle: String
   let updatedAt, publishedAt: String
    let sortOrder: String

    let publishedScope, title: String
    let bodyHTML: String?
    let adminGraphqlAPIID: String
   //let image: Image?

    enum CodingKeys: String, CodingKey {
        case id, handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case sortOrder = "sort_order"
        case publishedScope = "published_scope"
        case title
        case bodyHTML = "body_html"
        case adminGraphqlAPIID = "admin_graphql_api_id"
     //   case image
    }
}

// MARK: - Image
struct Image: Codable {
    let createdAt: Date
    let width, height: Int
    let src: String

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case  width, height, src
    }
}
