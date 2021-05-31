//
//  AlertExtention.swift
//  Shopy
//
//  Created by Amin on 31/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
extension UIViewController{
    
    func alert(title:String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
