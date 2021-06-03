//
//  PriceRules.swift
//  Shopy
//
//  Created by SOHA on 6/3/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
// MARK: - PriceRules
struct PriceRules: Codable {
    let priceRules: [PriceRule]

    enum CodingKeys: String, CodingKey {
        case priceRules = "price_rules"
    }
}

// MARK: - PriceRule
struct PriceRule: Codable {
    let id: Int
    let valueType: String
    let value: String
    let customerSelection: String
    let targetType: String
    let targetSelection: String
   

    enum CodingKeys: String, CodingKey {
        case id
        case valueType = "value_type"
        case value
        case customerSelection = "customer_selection"
        case targetType = "target_type"
        case targetSelection = "target_selection"
        
    }
}
