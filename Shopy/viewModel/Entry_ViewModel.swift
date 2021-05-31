//
//  Register_ViewModel.swift
//  Shopy
//
//  Created by Amin on 30/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import FirebaseAuth

class EntryViewModel {
    
    public var isAllTextFilld:Bool!
    public var isMailValid:Bool!
    init() {
        isAllTextFilld = false
        isMailValid = false
    }
    
    func checkForEmptyTextField(text: String?) -> EntryViewModel? {
        
        guard let myText = text else {return self}
        isAllTextFilld = !myText.isEmpty ? true : false
        
        if isAllTextFilld == false {
            return nil
        }
        return self
    }
    
    /// a function that returns a closure yes if the 2 passed parameters are equals, and return no else
    /// - Parameters:
    ///   - pass: password string
    ///   - conf: confirmation string
    ///   - yes: closure will be returned if pass and conf are equals && bool indicate if the fileds is empty or not
    ///   - no: closure will be returned if pass and conf are not equals
    /// - Returns: void
    func isPasswordMatching(pass:String?,conf:String?,yes:(Bool)->(),no:()->()) {
        guard let wrappedPass = pass,
              let wrappedConf = conf else {print("return");return}
        
        
        wrappedConf.count == 0 && wrappedPass.count == 0 ? yes(true) : wrappedPass == wrappedConf ? yes(false) : no()
        
    }

    func isMailValid(mail:String?,yes:(Bool)->(),no:(Bool)->()){
        guard let wrappedMail = mail else {return}
        let empty = wrappedMail.count == 0
        isMailValid =  wrappedMail.isValidEmail() ? true : false
        wrappedMail.isValidEmail() ? yes(empty) : no(empty)
    }
    
    func signUp(email:String,password:String,onSuccess:@escaping ()->(),onFailure:@escaping (String)->()) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        
            if let err = error {
                onFailure(err.localizedDescription)
            }else{
                onSuccess()
            }

        }
    }
    
    func signIn(email:String,password:String,onSuccess:@escaping ()->(),onFailure: @escaping(String)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let err = error{
                onFailure(err.localizedDescription)
            }else{
                print("login successfully")
                onSuccess()
            }
        }
    }
}
