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
    @IBOutlet weak var uiLocationBtn: UIButton!
    
    var viewModel:EntryViewModel!
    var address:Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tabBarController?.tabBar.isHidden = true
        viewModel = EntryViewModel()
        setupView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let loggedin = MyUserDefaults.getValue(forKey: .loggedIn){
            print("logged in is \(loggedin)")
        }else{
            print("non")
        }
        
    }
    func setupView() {
        roundView(uiView: uiView)
        uiSubmit.layer.cornerRadius = uiSubmit.layer.frame.height/2
        
        uiPassword.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        uiConfirmation.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        uiEmail.addTarget(self, action: #selector(checkMail), for: .editingChanged)
     
    }
        
    
    @objc func checkPassword(){
        viewModel.isPasswordMatching(pass: uiPassword.text, conf: uiConfirmation.text,
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
    
    
    
    func checkEmptyTexts(){
        
        let _ = viewModel.checkForEmptyTextField(text: uiFirstName.text)?
            .checkForEmptyTextField(text: uiLastName.text)?
            .checkForEmptyTextField(text: uiEmail.text)?
            .checkForEmptyTextField(text: uiPassword.text)?
            .checkForEmptyTextField(text: uiConfirmation.text)
        
    }
    
    @IBAction func uiSubmit(_ sender: UIButton) {
        
        checkEmptyTexts()
        viewModel.isPasswordMatching(pass: uiPassword.text, conf: uiConfirmation.text,
             yes: {empty in
                
                if empty == true{
                    onFaildHud(text: "Please Fill in The blanks!!")
                    
                }else{
                    
                    if viewModel.isAllTextFilld && viewModel.isMailValid {
//                        let hud = JGProgressHUD()
//                        hud.textLabel.text = "Loading"
//                        hud.style = .dark
//                        hud.show(in: self.view)
                        
                        guard let address = address else {
                            onFaildHud(text: "Please insert Address Data")
                            return
                        }
                        
                        let hud = loadingHud(text: "Please Wait", style: .dark)
                        let myAddress:[Address] = [address]
                        let newCustomer = Customer(customer: CustomerClass(firstName: uiFirstName.text!, lastName: uiLastName.text!, email: uiEmail.text!, phone: uiPhone.text!, password: uiPassword.text!, verifiedEmail: false, addresses: myAddress))
                        
                        viewModel.signUp(customer:newCustomer,
                                         onSuccess: { [unowned self] in
//                                            hud.dismiss()
//                                            self.dismissLoadingHud(hud: hud)
//                                            self.onSuccessHud()
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                                                self.viewModel.signIn(email: uiEmail.text!, password: uiPassword.text!, onSuccess: { [unowned self] in
                                                    self.dismissLoadingHud(hud: hud)
                                                    self.navigationController?.popViewController(animated: true)
                                                }) { [unowned self] (string) in
                                                    self.dismissLoadingHud(hud: hud)
                                                    self.onFaildHud(text: string)
                                                }
                                            }
                                            
                                            
                                         },onFailure: { [unowned self] localizedDescription in
                                            print(localizedDescription)
//                                            hud.dismiss()
                                            self.dismissLoadingHud(hud: hud)
                                            self.onFaildHud(text: localizedDescription)
                                         });
                        
                    }else if !viewModel.isMailValid {
                        onFaildHud(text: "Please Enter Valid Email!!")
                    }else{
                        onFaildHud(text: "Please Fill in The blanks!!")
                    }
                    
                }
                
             }, no: {
                onFaildHud(text: "Please confirm that you enter a valid passwords")
             })
    }
    
    @IBAction func listAddresses(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ListAddressesVC") as! AddressViewController
        let nav = UINavigationController(rootViewController: vc)
        
        nav.navigationController?.navigationBar.prefersLargeTitles = true
        nav.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        vc.delegate = self
        if let address = address{
            vc.address = address
        }
        present(nav, animated: true, completion: nil)
        
    }
    
    
}


//MARK:-secured password without suggestion
extension Register: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ( textField == self.uiPassword  ) {
            self.uiPassword.isSecureTextEntry = true
        }else if(textField == self.uiConfirmation ){
            self.uiConfirmation.isSecureTextEntry = true
        }
        
        return true
    }
}


//MARK:- receiving address list from delegat
extension Register:UIUPdateAddressList{
    func receive(address: Address?) {
        if let address = address{
            self.address = address
            uiLocationBtn.setImage(UIImage(systemName: "location.fill"), for: .normal)

        }else{
            self.address = nil
            uiLocationBtn.setImage(UIImage(systemName: "location"), for: .normal)
        }
        
    }
}
