//
//  DiscountCode.swift
//  Shopy
//
//  Created by SOHA on 6/3/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation


// MARK: - DiscountCode
struct DiscountCode: Codable {
    let discountCodes: [DiscountCodeElement]

    enum CodingKeys: String, CodingKey {
        case discountCodes = "discount_codes"
    }
}

// MARK: - DiscountCodeElement
struct DiscountCodeElement: Codable {
    let id, priceRuleID: Int
    let code: String
    let usageCount: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case priceRuleID = "price_rule_id"
        case code
        case usageCount = "usage_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
