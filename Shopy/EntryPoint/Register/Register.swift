//
//  Register.swift
//  Shopy
//
//  Created by Amin on 28/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class Register: UIViewController,IRounded {

    @IBOutlet var uiView: UIView!
    @IBOutlet weak var uiSubmit: UIButton!
    
    @IBOutlet weak var uiFirstName: UITextField!
    @IBOutlet weak var uiLastName: UITextField!
    @IBOutlet weak var uiEmail: UITextField!
    @IBOutlet weak var uiPassword: UITextField!
    @IBOutlet weak var uiPhone: UITextField!
    @IBOutlet weak var uiConfirmation: UITextField!
    
    @IBOutlet weak var uiPasswordlbl: UILabel!
    var isPasswordMatching:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tabBarController?.tabBar.isHidden = true
        
        isPasswordMatching = false
        uiPassword.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        uiConfirmation.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        setupView()
    }
    func setupView() {
        roundView(uiView: uiView)
        uiSubmit.layer.cornerRadius = uiSubmit.layer.frame.height/2
    }
    
    func isThereEmptyText() -> Bool {
        if uiFirstName.text?.isEmpty != true  && uiLastName.text?.isEmpty != true && uiEmail.text?.isEmpty != true && uiPassword.text?.isEmpty != true && uiConfirmation.text?.isEmpty != true{
            return false
        }else{
            return true
        }
    }
    
    @objc func checkPassword(){
        if uiPassword.text == uiConfirmation.text{
            isPasswordMatching = true
            uiPasswordlbl.isHidden = true
        }else{
            isPasswordMatching = false
            uiPasswordlbl.isHidden = false
        }
    }
    
    @IBAction func uiSubmit(_ sender: UIButton) {
        let textsState = isThereEmptyText()
        if isPasswordMatching && textsState != true{
            print("submit")
            
        }else{
            print("still")
        }
    }
}

