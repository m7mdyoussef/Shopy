//
//  RegisterErrorResponse.swift
//  Shopy
//
//  Created by Amin on 03/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation


// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    let errors: Errors?
}

// MARK: - Errors
struct Errors: Codable {
    let email, phone,addressesCountry,addressesZip,addressesCity,addressesTitle: [String]?
    
    enum CodingKeys: String, CodingKey {
        case email,phone
        case addressesCountry = "addresses.country"
        case addressesZip = "addresses.zip"
        case addressesCity = "addresses.city"
        case addressesTitle = "addresses.address1"
    }
    
//    let addresses:[AddressResponse]?
}
//struct AddressResponse:Codable {
//    let title,city,country,zip : [String]?
//
//    enum CodingKeys: String, CodingKey {
//        case title = "address1"
//        case city,country,zip
//    }
//}
