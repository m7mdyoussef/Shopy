//
//  Register_ViewModel.swift
//  Shopy
//
//  Created by Amin on 30/05/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import FirebaseAuth
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
        //        Auth.auth().createUser(withEmail: customer.customer.email!, password: pass) { [unowned self] authResult, error in
        ////            if let err = error {
        ////                onFailure(err.localizedDescription)
        ////            }else{
        //                self.registerACustomerInApi(newUser: customer)
        //                onSuccess()
        ////            }
        //
        //        }
        remote.registerACustomer(customer: customer) { (data) in
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
        } onFailure: { (err) in
            DispatchQueue.main.async {
                onFailure(err.localizedDescription)
                print("error is \(err.localizedDescription)")
            }
            
        }
        
    }
    
    func registerACustomerInApi(newUser:Customer) {
        //        remote.registerACustomer(customer: newUser) { (result) in
        //            if let err = (result as? NSError) {
        //                print("error is \(err.localizedDescription)")
        //            }else{
        //                print("else is  \(result)")
        //            }
        //        }
        
        //        remote.registerACustomer(customer: newUser) { (data) in
        //            if let decodedResponse = try? JSONDecoder().decode(RegisterError.self, from: data) {
        //                if let email = decodedResponse.errors.email{
        //                    print("email \(email[0])")
        //                }
        //                if let phone = decodedResponse.errors.phone{
        //                    print("phone \(phone[0])")
        //                }
        //
        //            }else{
        //                print("errrr")
        //            }
        //        } onFailure: { (err) in
        //            print("error is \(err.localizedDescription)")
        //        }
        
        
        
        //        let urlString = "https://ce751b18c7156bf720ea405ad19614f4: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@itiana.myshopify.com/admin/api/2021-04/customers.json"
        //               guard let url = URL(string: urlString) else {return}
        //               var request = URLRequest(url: url)
        //               request.httpMethod = "POST"
        //               let session = URLSession.shared
        //               request.httpShouldHandleCookies = false
        //
        //
        //               do {
        //                request.httpBody = try JSONSerialization.data(withJSONObject: newUser.asDictionary(), options: .prettyPrinted)
        //               } catch let error {
        //                   print(error.localizedDescription)
        //               }
        //
        //               HTTP Headers
        //               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //               request.addValue("application/json", forHTTPHeaderField: "Accept")
        //
        //        session.dataTask(with: request) { (data, response, error) in
        //            if error != nil {
        //                print(error!)
        //            } else {
        //                if let data = data {
        //                 let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        //                    print(json)
        //                    print(data)
        //                }
        //            }
        //        }.resume()
        
    }
    
    func signIn(email:String,password:String,onSuccess:@escaping ()->(),onFailure: @escaping(String)->Void) {
        //        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
        //            if let err = error{
        //                onFailure(err.localizedDescription)
        //            }else{
        //                print("login successfully")
        //                onSuccess()
        //            }
        //        }
        getAllUsers { (allCustomers) in
            
            for customer in allCustomers.customers{
                if let mail = customer.email {
                    if email == mail && password == customer.password{
                        MyUserDefaults.add(val: true, key: .loggedIn)
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
            
        } onError: { (err) in
            print(err)
            DispatchQueue.main.async {
                onFailure(err)
            }
        }
        
    }
    
    func getAllUsers(onFinish: @escaping (AllCustomers)->Void,onError: @escaping (String)->Void) {
        remote.getAllUsers { (allCustomers) in
            guard let customer = allCustomers else {return}
            onFinish(customer)
        } onError: { (err) in
            onError(err.localizedDescription)
        }
    }
}
