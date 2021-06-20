//
//  Userdefaults.swift
//  Shopy
//
//  Created by Amin on 04/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation


enum Themes : String{
    case dark = "dark"
    case light = "ligh"
}
enum Keys:String {
    case isFirstTime = "isFirstTime"
    case theme = "theme"
    case email = "email"
    case username = "username"
    case loggedIn = "logedIn"

    case id = "id"
    case isDisconut = "discount"
    case discountCode = "DiscountCode"
    case phone = "phone"
    case title = "address"
    case city = "city"
    case country = "country"
    case password = "password"
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
