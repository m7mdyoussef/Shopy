//
//  OrderObject.swift
//  Shopy
//
//  Created by Amin on 12/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

struct OrderObject {
    let products:[BagProduct]
    let total:Double
    let subTotal:Double
    let discount:Double
}
