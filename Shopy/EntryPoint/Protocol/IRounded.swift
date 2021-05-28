//
//  IRounded.swift
//  Shopy
//
//  Created by Amin on 25/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import UIKit
public protocol IRounded {
    var BOTTOM_VIEW_CORNER_RADIUS:Double {get}
    func roundView(uiView:UIView)
}

extension IRounded{
    var BOTTOM_VIEW_CORNER_RADIUS:Double {return 50}
    func roundView(uiView:UIView){
        uiView.layer.cornerRadius = CGFloat(BOTTOM_VIEW_CORNER_RADIUS)
        uiView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
