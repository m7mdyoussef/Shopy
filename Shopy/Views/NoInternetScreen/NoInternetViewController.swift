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
//    var vc: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
 
    
    @IBAction func tryAgain(_ sender: Any) {
        print("clicked")
        if AppCommon.shared.checkConnectivity() == true{
            self.dismiss(animated: true, completion: nil)
            // self.navigationController?.popViewController(animated: true)
//            if fromWhere == "category" {
//                let vc = self.storyboard?.instantiateViewController(identifier: "CategoryViewController") as! CategoryViewController
//
//            }

        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
