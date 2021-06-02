//
//  Customer.swift
//  Shopy
//
//  Created by Amin on 01/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation


extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}


// MARK: - Customer
struct Customer: Codable {
    let customer: CustomerClass
}

// MARK: - CustomerClass
struct CustomerClass: Codable {
    let firstName, lastName, email, phone: String?
    let verifiedEmail: Bool
    let addresses: [Address]

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case verifiedEmail = "verified_email"
        case addresses
    }
}

// MARK: - Address
struct Address: Codable {
    let address1, city, province, phone: String?
    let zip, lastName, firstName, country: String?

    enum CodingKeys: String, CodingKey {
        case address1, city, province, phone, zip
        case lastName = "last_name"
        case firstName = "first_name"
        case country
    }
}
