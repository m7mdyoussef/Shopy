//
//  AlertExtention.swift
//  Shopy
//
//  Created by Amin on 31/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import JGProgressHUD
extension UIViewController{
    
    func alert(title:String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func onSuccessHud() {
        let hud = JGProgressHUD()
        hud.textLabel.text = "Success"
        hud.show(in: self.view)
        hud.style = .dark
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 3.0)
    }
    
    func onFaildHud(text:String) {
        let hud = JGProgressHUD()
        hud.textLabel.text = "\(text)"
        hud.show(in: self.view)
        hud.style = .dark
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.dismiss(afterDelay: 3.0)
    }
    
    func loadingHud(text : String,style:JGProgressHUDStyle) -> JGProgressHUD{
        let hud = JGProgressHUD()
        hud.textLabel.text = "Loading"
        hud.style = style
        hud.show(in: self.view)
        return hud
    }
    
    func dismissLoadingHud(hud:JGProgressHUD)  {
        hud.dismiss()
    }
}
