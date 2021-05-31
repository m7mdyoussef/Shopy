//
//  Login.swift
//  Shopy
//
//  Created by Amin on 28/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class Login: UIViewController,IRounded{

    @IBOutlet var uiView: UIView!
    @IBOutlet weak var uiEmail: UITextField!
    @IBOutlet weak var uiPassword: UITextField!
    @IBOutlet weak var uiLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        print("welcom in login")
    }
    
    func setupView() {
        roundView(uiView: uiView)
        uiLogin.layer.cornerRadius = uiLogin.layer.frame.height/2
    }

}
