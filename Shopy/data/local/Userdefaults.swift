//
//  Userdefaults.swift
//  Shopy
//
//  Created by Amin on 04/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

enum Keys:String {
    case isFirstTime = "isFirstTime"
    case email = "email"
    case username = "username"
    case loggedIn = "logedIn"

    case id = "id"
    case isDisconut = "discount"
    case phone = "phone"
    case title = "address"
    case city = "city"
    case country = "country"
}
class MyUserDefaults {
    private static var shared = UserDefaults.standard
    
    private init(){
        
    }
    public static func add<T>(val : T,key : Keys){
        shared.setValue(val, forKey: key.rawValue)
    }
    
    public static func getValue(forKey key: Keys) -> Any?{
        return shared.value(forKey: key.rawValue) ?? nil
    }
}
