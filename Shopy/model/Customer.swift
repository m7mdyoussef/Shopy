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

struct AllCustomers:Codable {
//    let customers: [CustomerClass]
        let customers: [CustomerPostOrder]
}

struct CustomerPostOrder: Codable {
    let id : Int
    let firstName, lastName, email,phone: String?
    let password : String
    let verifiedEmail: Bool
    let addresses: [Address]

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case verifiedEmail = "verified_email"
        case addresses
        case password = "tags"
    }
}


// MARK: - CustomerClass
struct CustomerClass: Codable {
    let firstName, lastName, email,phone: String?
    let password : String
    let verifiedEmail: Bool
    let addresses: [Address]

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case verifiedEmail = "verified_email"
        case addresses
        case password = "tags"
    }
}

// MARK: - Address
struct Address: Codable {
    let title, city: String?
    let zip, country: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "address1"
        case city,zip,country
    }
}
