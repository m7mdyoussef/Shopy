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
    var status : String?
    @IBOutlet weak var switchTheme: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MeTapViewModel()
        status = viewModel.isUserLoggedIn() ? "Logout".localized : "Login".localized
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
        let vc = self.storyboard?.instantiateViewController(identifier: "Register") as! Register
        
        self.viewModel.getCustomerData { (customer,id) in
            vc.customer = customer
            vc.customerID = id
            self.present(vc, animated: true, completion: nil)
        } onError: {
            vc.customer = nil
            self.present(vc, animated: true, completion: nil)
        }
}


@IBAction func logout(_ sender: Any) {
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
        
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        logout.addAction(ok)
        logout.addAction(cancel)
        self.present(logout, animated: true, completion: nil)
    }
    
    
}
}
