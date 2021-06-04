//
//  Login.swift
//  Shopy
//
//  Created by Amin on 28/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import JGProgressHUD

class Login: UIViewController,IRounded{

    @IBOutlet var uiView: UIView!
    @IBOutlet weak var uiEmail: UITextField!
    @IBOutlet weak var uiPassword: UITextField!
    @IBOutlet weak var uiLogin: UIButton!
    @IBOutlet weak var uiMaillbl: UILabel!
    var viewModel:EntryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = EntryViewModel()
        setupView()
        
    }
    
    func setupView() {
        roundView(uiView: uiView)
        uiLogin.layer.cornerRadius = uiLogin.layer.frame.height/2
        uiEmail.addTarget(self, action: #selector(checkMail), for: .editingChanged)
    }
    
    @objc func checkMail(){
        viewModel.isMailValid(mail: uiEmail.text,
        yes: { empty in
            if empty{
                uiMaillbl.isHidden = true
            }else{
                uiMaillbl.isHidden = false
                uiMaillbl.textColor = .systemGreen
                uiMaillbl.text = MailState.valid.rawValue
            }
        }, no: { empty in
            if empty{
                uiMaillbl.isHidden = true
            }else{
                uiMaillbl.isHidden = false
                uiMaillbl.text = MailState.notValid.rawValue
                uiMaillbl.textColor = .systemRed
            }
        })
    }

    @IBAction func uiLogin(_ sender: UIButton) {
            
        guard let mail = uiEmail.text,
              let pass = uiPassword.text else {
            return
        }
        
        if !(mail.isEmpty) && !(pass.isEmpty) {
            let hud = JGProgressHUD()
            hud.textLabel.text = "Loading"
            hud.style = .dark
            hud.show(in: self.view)
            viewModel.signIn(email: uiEmail.text!, password: uiPassword.text!) { [unowned self] in
                hud.dismiss()
                self.onSuccessHud()
                //MARK:- redirect
            } onFailure: { [unowned self] (string) in
                hud.dismiss()
                self.onFaildHud(text: string)
            }

        }else{
            onFaildHud(text: "Please Fill in The blanks !!")
        }
    }
}

extension Login : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.uiPassword {
            textField.isSecureTextEntry = true
        }
        return true
    }
}
