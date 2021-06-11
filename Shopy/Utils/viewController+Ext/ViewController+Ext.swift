//
//  ViewController+Ext.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 10/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

extension UIViewController{
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = AlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
