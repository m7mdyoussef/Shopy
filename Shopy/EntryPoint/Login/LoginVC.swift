//
//  LoginVC.swift
//  Shopy
//
//  Created by Amin on 25/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class LoginVC: UIViewController , IRounded{

    @IBOutlet weak var uiView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func setupView() {
        roundView(uiView: uiView)
    }

}
