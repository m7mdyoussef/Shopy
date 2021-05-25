//
//  RegisterVC.swift
//  Shopy
//
//  Created by Amin on 25/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController , IRounded{

    @IBOutlet var uiView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        roundView(uiView: uiView)
    }
}
