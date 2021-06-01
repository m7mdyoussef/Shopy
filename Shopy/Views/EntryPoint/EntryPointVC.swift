//
//  RegisterVC.swift
//  Shopy
//
//  Created by Amin on 25/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class EntryPointVC: UIViewController {

    @IBOutlet weak var uiSegment: UISegmentedControl!
    var notificationName:Notification.Name!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationName = Notification.Name("EntryScreen")
    }
    
    @IBAction func uiSegmentAction(_ sender: UISegmentedControl) {
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["key":uiSegment.selectedSegmentIndex])
    }
}
