//
//  Order.swift
//  Shopy
//
//  Created by Amin on 08/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

enum FinancialStatus:String {
    case pending = "pending"
    case authorized = "authorized"
    case partiallyPaid = "partially_paid"
    case paid = "paid"
    case partiallyRefunded = "partially_refunded"
    case voided = "voided"
}


struct Orders: Codable {
    let orders: [Order]
}

// MARK: - currencyOrderClass
struct Order: Codable {
    let id: Int
    let totalDiscounts, totalPrice, totalTax, totalPriceUsd: String
    let discountCodes: [OrderDiscountCode]?
    let email, financialStatus, name: String
    let fulfillmentStatus:String?
    let orderNumber: Int
    let orderStatusURL: String
    let lineItems: [LineItems]

    enum CodingKeys: String, CodingKey {
        case id
        case totalDiscounts = "total_discounts"
        case totalPrice = "total_price"
        case totalTax = "total_tax"
        case totalPriceUsd = "total_price_usd"
        case discountCodes = "discount_codes"
        case email
        case financialStatus = "financial_status"
        case fulfillmentStatus = "fulfillment_status"
        case name
        case orderNumber = "order_number"
        case orderStatusURL = "order_status_url"
        case lineItems = "line_items"
    }
}

// MARK: - currencyLineItem
struct LineItems: Codable {
    let id: Int
    let giftCard: Bool
    let name, price: String
    let productExists: Bool
    let productID:Int?
    let quantity: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case giftCard = "gift_card"
        case name, price
        case productExists = "product_exists"
        case productID = "product_id"
        case quantity
        case title
    }
}

// MARK: - currencyDiscountCode
struct OrderDiscountCode: Codable {
    let code, amount, type: String
}
