//
//  ShowIndecator.swift
//  Shopy
//
//  Created by mohamed youssef on 5/20/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//


import Foundation
import UIKit
import NVActivityIndicatorView

class ShowIndecator {
    
    var activityIndicator : NVActivityIndicatorView?
    var view : UIView?
    init(view:UIView) {
        self.view = view
        activityIndicator = NVActivityIndicatorView(frame: .zero, type: .ballPulse, color: .blue, padding: 0)
    }
    fileprivate func makeIndicator() {
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        view?.addSubview(activityIndicator!)
        NSLayoutConstraint.activate([
            activityIndicator!.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator!.heightAnchor.constraint(equalToConstant: 40),
            activityIndicator!.centerXAnchor.constraint(equalTo: view!.centerXAnchor),
            activityIndicator!.centerYAnchor.constraint(equalTo: view!.centerYAnchor)
        ])
    }
    
    func startAnimating() {
        makeIndicator()
        activityIndicator?.startAnimating()
    }
    func stopAnimating() {
        activityIndicator?.stopAnimating()
    }
}
