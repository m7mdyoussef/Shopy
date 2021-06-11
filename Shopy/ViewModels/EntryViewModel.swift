//
//  Register_ViewModel.swift
//  Shopy
//
//  Created by Amin on 30/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import Alamofire
class EntryViewModel {
    
    public var isAllTextFilld:Bool!
    public var isMailValid:Bool!
    var remote:RemoteDataSource!
    init() {
        isAllTextFilld = false
        isMailValid = false
        remote = RemoteDataSource()
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
    
    func signUp(customer:Customer,onSuccess:@escaping ()->(),onFailure:@escaping (String)->()) {
        
        remote.registerACustomer(customer: customer,onCompletion: { (data) in
            if let decodedResponse = try? JSONDecoder().decode(RegisterResponse.self, from: data) {
                if let email = decodedResponse.errors?.email{
                    let err = "email \(email[0])"
                    DispatchQueue.main.async {
                        onFailure(err)
                    }
                }else
                if let phone = decodedResponse.errors?.phone{
                    let err = "phone \(phone[0])"
                    DispatchQueue.main.async {
                        onFailure(err)
                    }
                }else{
                    DispatchQueue.main.async {
                        onSuccess()
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    onFailure("an Error Occured, Try Again Later")
                }
            }
        } ) { (err) in
            DispatchQueue.main.async {
                onFailure(err.localizedDescription)
                print("error is \(err.localizedDescription)")
            }
            
        }
        
    }
        
    func signIn(email:String,password:String,onSuccess:@escaping ()->(),onFailure: @escaping(String)->Void) {
 
        getAllUsers(onFinish:{ [unowned self] (allCustomers) in
            
            for i in allCustomers.customers{
                if let mail = i.email {
                    
                    if email == mail , password == i.password{
                        self.saveCredentialsInUserDefaults(email: email, username: i.firstName!,id: i.id)
                        DispatchQueue.main.async {
                            onSuccess()
                        }
                        return
                    }
                }
            }
            
            DispatchQueue.main.async {
                print("onfalure")
                onFailure("Credentials is no valid, Please Try again")
            }
            
        }) { (err) in
            print(err)
            DispatchQueue.main.async {
                onFailure(err)
            }
        }
        
    }
    
    
    
    func saveCredentialsInUserDefaults(email:String,username:String,id:Int) {
        MyUserDefaults.add(val: true, key: .loggedIn)
        MyUserDefaults.add(val: email, key: .email)
        MyUserDefaults.add(val: username, key: .username)
        MyUserDefaults.add(val: id, key: .id)
    }
    
    func getAllUsers(onFinish: @escaping (AllCustomers)->Void,onError: @escaping (String)->Void) {
        
        
        remote.getAllUsers(onSuccess: { (allCustomers) in
            guard let customer = allCustomers else {return}
            onFinish(customer)
        }){ (err) in
            onError(err.localizedDescription)
        }
    }
}
