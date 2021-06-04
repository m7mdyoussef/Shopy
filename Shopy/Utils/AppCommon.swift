//
//  App Common.swift
//  Shopy
//
//  Created by SOHA on 5/31/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import SwiftMessages

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func circular() {
        self.layer.cornerRadius = self.frame.height/2
    }
    
    func collectionCellLayout(){
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
}

enum ReachabilityStatus {
    case notReachable
    case reachableViaWWAN
    case reachableViaWiFi
}

class AppCommon: NSObject {
    static let shared = AppCommon()
 var currentReachabilityStatus: ReachabilityStatus {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return .notReachable
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return .notReachable
    }
    
    if flags.contains(.reachable) == false {
        // The target host is not reachable.
        return .notReachable
    } else if flags.contains(.isWWAN) == true {
        // WWAN connections are OK if the calling application is using the CFNetwork APIs.
        return .reachableViaWWAN
    } else if flags.contains(.connectionRequired) == false {
        // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
        return .reachableViaWiFi
    } else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
        // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
        return .reachableViaWiFi
    } else {
        return .notReachable
    }
}
    
    func showSwiftMessage(title: String = "", message: String = "", theme: Theme = .error) {
        let view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(theme)
        view.configureDropShadow()
        view.button?.isHidden = true
        view.configureContent(title: title, body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        SwiftMessages.show(view: view)
        
    }
    
    func checkConnectivity() -> Bool {
        if currentReachabilityStatus != .notReachable {
            return true
        } else {
            showSwiftMessage(title: "Error", message: "Please Check Your Internet Connection", theme: .error)
            return false
        }
    }

}
