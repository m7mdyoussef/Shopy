//
//  SettingsVC.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 09/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import MOLH
struct SettingOptions {
    var title:String
    var handler:()->Void
}
class SettingsVC: UIViewController {
    
    var settings = [SettingOptions(title: "English".localized, handler: {
        print("change language")
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        if #available(iOS 13.0, *) {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate!.swichRoot()
        } else {
            // Fallback on earlier versions
            MOLH.reset()
        }
    }),SettingOptions(title: "logout", handler: {
        print("logged out")
    })]
    
    
    @IBOutlet weak var settingsTableView: UITableView!{
        didSet{
            settingsTableView.delegate   = self
            settingsTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        configureUI()
    }
    fileprivate func registerCell(){
        let cell = UINib(nibName: "SettingsTableViewCell", bundle: nil)
        //        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsTableViewCell")
        settingsTableView.register(cell, forCellReuseIdentifier: "SettingsTableViewCell")
    }
    
    fileprivate func configureUI(){
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
extension SettingsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        
        cell.settingOptionLabel.text = settings[indexPath.row].title
        //        cell.textLabel?.text = "ggg"
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(systemName: "trash.fill")
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheetViewController = UIAlertController(title: "DDDD", message: "dddddd", preferredStyle: .alert)
        
        // Present it w/o any adjustments so it uses the default sheet presentation.
        //               present(sheetViewController, animated: true, completion: nil)
        settings[indexPath.row].handler()
    }
    
}
