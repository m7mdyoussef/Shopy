//
//  Register.swift
//  Shopy
//
//  Created by Amin on 28/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import JGProgressHUD

enum PasswordState:String {
    case match = "Password does not match"
    case dont = "Matched Passwords"
}

enum MailState:String {
    case valid = "Email is Valid"
    case notValid = "Email is not valid"
}


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
    @IBOutlet weak var uiMaillbl: UILabel!
    
    var viewModl:EntryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tabBarController?.tabBar.isHidden = true
        
        viewModl = EntryViewModel()
    
        setupView()
    }
    func setupView() {
        roundView(uiView: uiView)
        uiSubmit.layer.cornerRadius = uiSubmit.layer.frame.height/2
        
        uiPassword.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        uiConfirmation.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        uiEmail.addTarget(self, action: #selector(checkMail), for: .editingChanged)
    }
    
    func checkEmptyTexts(){
        
        let _ = viewModl.checkForEmptyTextField(text: uiFirstName.text)?
            .checkForEmptyTextField(text: uiLastName.text)?
            .checkForEmptyTextField(text: uiEmail.text)?
            .checkForEmptyTextField(text: uiPassword.text)?
            .checkForEmptyTextField(text: uiConfirmation.text)
        
    }
    
    @objc func checkPassword(){
        viewModl.isPasswordMatching(pass: uiPassword.text, conf: uiConfirmation.text,
                    yes: {empty in
                        
                        if empty == true{
                            uiPasswordlbl.isHidden = true
                        }else{
                            uiPasswordlbl.isHidden = false
                            uiPasswordlbl.textColor = .systemGreen
                            uiPasswordlbl.text = PasswordState.dont.rawValue
                        }
                        
                    }, no: {
                        uiPasswordlbl.isHidden = false
                        uiPasswordlbl.text = PasswordState.match.rawValue
                        uiPasswordlbl.textColor = .systemRed
                    })
    }
    @objc func checkMail(){
        viewModl.isMailValid(mail: uiEmail.text,
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
    
    @IBAction func uiSubmit(_ sender: UIButton) {
        checkEmptyTexts()
        viewModl.isPasswordMatching(pass: uiPassword.text, conf: uiConfirmation.text,
        yes: {empty in
            
            if empty == true{
                onFaildHud(text: "Please Fill in The blanks!!")

            }else{
                
                if viewModl.isAllTextFilld && viewModl.isMailValid {
                    let hud = JGProgressHUD()
                    hud.textLabel.text = "Loading"
                    hud.style = .dark
                    hud.show(in: self.view)
                    viewModl.signUp(email: uiEmail.text!, password: uiPassword.text!,
                    onSuccess: { [unowned self] in
                        hud.dismiss()
                        onSuccessHud()
                        //MARK:- redirection
                    },onFailure: { [unowned self] localizedDescription in
                        print(localizedDescription)
                        hud.dismiss()
                        onFaildHud(text: localizedDescription)
                    });
                    
                }else if !viewModl.isMailValid {
                    onFaildHud(text: "Please Enter Valid Email!!")
                }else{
                    onFaildHud(text: "Please Fill in The blanks!!")
                }
                
            }
                
        }, no: {
            onFaildHud(text: "Please confirm that you enter a valid passwords")
        })
    }
    
}

extension Register: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ( textField == self.uiPassword && !self.uiPassword.isSecureTextEntry ) {
             self.uiPassword.isSecureTextEntry = true
        }else if(textField == self.uiConfirmation && !self.uiConfirmation.isSecureTextEntry){
             self.uiConfirmation.isSecureTextEntry = true
        }

         return true
    }
}

