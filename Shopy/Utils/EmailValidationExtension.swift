//
//  EmailValidationExtension.swift
//  Shopy
//
//  Created by Amin on 31/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
extension String{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
