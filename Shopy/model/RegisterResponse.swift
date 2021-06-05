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
    let email, phone: [String]?
}
