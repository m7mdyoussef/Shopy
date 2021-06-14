//
//  NoInternetViewController.swift
//  Shopy
//
//  Created by mohamed youssef on 6/6/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {
    
    var fromWhere: String = ""
    var vcIdentifier: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tryAgain(_ sender: Any) {
        print("clicked")
        if AppCommon.shared.checkConnectivity() == true{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
