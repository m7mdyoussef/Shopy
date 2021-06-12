//
//  ICanLogin.swift
//  Shopy
//
//  Created by Amin on 12/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

protocol ICanLogin {
    func isUserLoggedIn() -> Bool
}

extension ICanLogin{
    func isUserLoggedIn() -> Bool{
        let value = MyUserDefaults.getValue(forKey: .loggedIn)
        guard let isLoggedIn = value else {return false}
        return (isLoggedIn as! Bool) ? true : false
    }
}
