//
//  RegisterVC.swift
//  Shopy
//
//  Created by Amin on 25/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class EntryPointVC: UIViewController {

    @IBOutlet private weak var uiSegment: UISegmentedControl!
    private var notificationName:Notification.Name!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        notificationName = Notification.Name("EntryScreen")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        tabBarController?.tabBar.isHidden = true
    }
    @IBAction func uiSegmentAction(_ sender: UISegmentedControl) {
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["key":uiSegment.selectedSegmentIndex])
    }
    
    @IBAction func uiSwipeToRight(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(identifier: "CollectionViewController") as! CollectionViewController
//        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uiClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
