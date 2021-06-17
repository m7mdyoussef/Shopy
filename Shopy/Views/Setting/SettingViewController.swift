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
    @IBOutlet weak var uiEditprofile: UIButton!
    @IBOutlet weak var uiLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MeTapViewModel()
        tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Settings".localized
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.backButtonTitle = "Profile".localized
        status = viewModel.isUserLoggedIn() ? "Logout".localized : "Login".localized
        setTheme()
        
        if viewModel.isUserLoggedIn(){
            uiEditprofile.isHidden = false
            uiLogout.setTitle(" Logout".localized, for: .normal)
        }else{
            uiEditprofile.isHidden = true
            uiLogout.setTitle(" Login".localized, for: .normal)
        }
    }
    
    func setTheme(){
        let status = viewModel.isLightTheme()
        switchTheme.setOn(!status , animated: true)
        view.window?.overrideUserInterfaceStyle = status ? .light : .dark
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
        //        if switchTheme.isOn == true{
        //
        //            guard (UIApplication.shared.delegate as? AppDelegate) != nil else {
        //                return
        //            }
        //            view.window?.overrideUserInterfaceStyle = .dark
        //        }
        //        else{
        //            guard (UIApplication.shared.delegate as? AppDelegate) != nil else {
        //                return
        //            }
        //            view.window?.overrideUserInterfaceStyle = .light
        //        }
        
        viewModel.toggleTheme()
        setTheme()
        
    }
    @IBAction func editProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "EntryPointVC") as! EntryPointVC
        vc.modalPresentationStyle = .fullScreen
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
                self.navigationController?.popViewController(animated: true)
//                self.dismiss(animated: true,completion: nil)
            }
            
            let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            logout.addAction(ok)
            logout.addAction(cancel)
            self.present(logout, animated: true, completion: nil)
        }
        
        
    }
}
