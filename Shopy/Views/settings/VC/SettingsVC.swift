//
//  SettingsVC.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 09/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
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
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsTableViewCell")
    }

    fileprivate func configureUI(){
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
extension SettingsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) //as! SettingsTableViewCell
        cell.textLabel?.text = "ggg"
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(systemName: "trash.fill")
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheetViewController = UIAlertController(title: "DDDD", message: "dddddd", preferredStyle: .alert)
               
               // Present it w/o any adjustments so it uses the default sheet presentation.
               present(sheetViewController, animated: true, completion: nil)
    }
    
}
