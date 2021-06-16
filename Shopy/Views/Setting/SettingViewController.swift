//
//  SettingViewController.swift
//  Shopy
//
//  Created by SOHA on 6/15/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import MOLH
class SettingViewController: UIViewController {
    var viewModel:MeTapViewModel!
    
    @IBOutlet weak var switchTheme: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MeTapViewModel()
    }
    

    @IBAction func changeLanguage(_ sender: Any) {
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        if #available(iOS 13.0, *) {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate!.swichRoot()
            
        } else {
            // Fallback on earlier versions
            MOLH.reset()
        }
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if switchTheme.isOn == true{
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               return
            }
            view.window?.overrideUserInterfaceStyle = .dark
        }
        else{
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               return
            }
            view.window?.overrideUserInterfaceStyle = .light
        }
    }
    @IBAction func editProfile(_ sender: Any) {
    }
    
    
    @IBAction func logout(_ sender: Any) {
        let status = viewModel.isUserLoggedIn() ? "Logout".localized : "Login".localized
        if status == "Login".localized{
            let vc = self.storyboard?.instantiateViewController(identifier: "EntryPointVC") as! EntryPointVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else{
            let logout = UIAlertController(title: "Logout".localized, message: "Are you sure ?".localized, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK".localized, style: .destructive) { (action) in
                self.viewModel.logout()
                self.tabBarController?.selectedIndex = 0
                self.viewModel.fetchFavProducts()
                self.viewModel.fetchOrders()

            }
    }
    
}
}
