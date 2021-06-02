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
    
    func signUp(customer:Customer,pass:String,onSuccess:@escaping ()->(),onFailure:@escaping (String)->()) {
        Auth.auth().createUser(withEmail: customer.customer.email!, password: pass) { [unowned self] authResult, error in
            
            if let err = error {
                onFailure(err.localizedDescription)
            }else{
                self.registerACustomerInApi(newUser: customer)
                onSuccess()
            }
            
        }
    }
    
    func registerACustomerInApi(newUser:Customer) {
        remote.registerACustomer(customer: newUser) { (result) in
            print(result)
        }
        
        
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
