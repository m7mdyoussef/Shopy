//
//  RegisterVC.swift
//  Shopy
//
//  Created by Amin on 25/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class EntryPointVC: UIViewController {

    @IBOutlet private weak var uiBottomView: UIView!
    
    var views:[UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        views = [UIView]()
        views.append(RegisterVC().view)
        views.append(LoginVC().view)
        
        for v in views {
            uiBottomView.addSubview(v)
        }
        uiBottomView.bringSubviewToFront(views[0])
                
    }
    
    @IBAction func uiSegmentAction(_ sender: UISegmentedControl) {
        uiBottomView.bringSubviewToFront(views[sender.selectedSegmentIndex])
    }
    

}
