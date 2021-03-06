//
//  MeTapViewModel.swift
//  Shopy
//
//  Created by Amin on 07/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MOLH

protocol MeModelType{
    
    func fetchFavProducts()
    func getUserName() -> String?
    func fetchOrders()
    func getFormattedDate(date:String) -> String?
    
    var favProductsObservable: Driver<[FavouriteProduct]>?{get}
    var ordersObservable: Driver<[Order]>?{get}
    var orderProductsObservable : Driver<[Product]>?{get}
    var loadingObservable: Driver<Bool>{get}
}

class MeTapViewModel:MeModelType,ICanLogin {
    
    var favProductsObservable: Driver<[FavouriteProduct]>?
    var ordersObservable: Driver<[Order]>?
    var orderProductsObservable: Driver<[Product]>?
    var loadingObservable: Driver<Bool>
    
    private var favProductsSubject = PublishSubject<[FavouriteProduct]>()
    private var ordersSubject = PublishSubject<[Order]>()
    private var orderProductSubject = PublishSubject<[Product]>()
    private var loadingSubject = PublishSubject<Bool>()
    
    private var remote:RemoteDataSource!
    private var dispatchGroup : DispatchGroup!
    init() {
        favProductsObservable = favProductsSubject.asDriver(onErrorJustReturn: [])
        ordersObservable = ordersSubject.asDriver(onErrorJustReturn: [])
        orderProductsObservable = orderProductSubject.asDriver(onErrorJustReturn: [])
        loadingObservable = loadingSubject.asDriver(onErrorJustReturn: true)
        remote = RemoteDataSource()
        dispatchGroup = DispatchGroup()
    }
    
    func fetchFavProducts() {
        
        if isUserLoggedIn(){
            let localData = FavouritesPersistenceManager.shared
            guard let favourites = localData.retrieveFavourites() else {
                return
            }
            self.favProductsSubject.asObserver().onNext(favourites)
        }else{
            self.favProductsSubject.asObserver().onNext([])
        }
    }
    
    func fetchOrders()  {
        
        if isUserLoggedIn(){
            loadingSubject.asObserver().onNext(true)
            remote.fetchOrders() { [unowned self] (result) in
                switch result{
                case .success(let response):
                    guard let orders = response?.orders else {return}
                    print("success")
                    self.ordersSubject.asObserver().onNext(self.getOrdersWithEmail(orders: orders))
                    self.loadingSubject.onNext(false)
                    
                case .failure(let error):
                    AppCommon.shared.showSwiftMessage(title: "Error", message: error.localizedDescription , theme: .error)
                    self.loadingSubject.onNext(false)
                }
            }
        }else{
            self.ordersSubject.asObserver().onNext([])
        }
    }
    
    private func getOrdersWithEmail(orders:[Order])-> [Order] {
        let email = MyUserDefaults.getValue(forKey: .email) as! String
        var array = [Order]()
        for i in orders{
            if email == i.email{
                array.append(i)
            }
        }
        return array
    }
    
    
    //    func isUserLoggedIn() -> Bool {
    //        let value = MyUserDefaults.getValue(forKey: .loggedIn)
    //        guard let isLoggedIn = value else {return false}
    //
    //        return (isLoggedIn as! Bool) ? true : false
    //    }
    
    func getUserName() -> String? {
        
        if let username = MyUserDefaults.getValue(forKey: .username){
            return username as? String
        }else{
            return nil
        }
        
    }
    
    func fetchOrderProducts(orderLineItems: [LineItems]) {
        
        var products = [Product]()
        
        for item in orderLineItems{
            guard let id = item.productID else {return}
            dispatchGroup.enter()
            remote.getProductElement(productId: String(id)) { [unowned self] (result) in
                
                self.dispatchGroup.leave()
                switch result{
                case .success(let product):
                    guard let product = product else {return}
                    products.append(product)
                    print(products)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
        dispatchGroup.notify(queue:.main) { [unowned self] in
            self.orderProductSubject.asObserver().onNext(products)
        }
    }
    
    func getFormattedDate(date: String) -> String? {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // api iso format
//        if let date = formatter.date(from: date) {
//            formatter.dateFormat = "EEEE, MMM d, yyyy"
//            return formatter.string(from: date)
//        }
//        return nil
        
        date.getNamedDayNamedMonthYear()
    }
    
    func removeAllOrders(completion: @escaping ()->Void) {
        loadingSubject.asObserver().onNext(true)
        
        remote.fetchOrders { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let response):
                guard let orders = response?.orders else {return}
                print("success")
                
                let myOrders = self.getOrdersWithEmail(orders: orders)
                for order in myOrders{
                    //                    self.dispatchGroup.enter()
                    self.remote.removeOrder(id:order.id)
                }
                
                self.loadingSubject.onNext(false)
                completion()
                
            case .failure(let error):
                AppCommon.shared.showSwiftMessage(title: "Error", message: error.localizedDescription , theme: .error)
                self.loadingSubject.onNext(false)
                self.loadingSubject.asObserver().onNext(false)
            }
        }
    }
    func logout() {
        MyUserDefaults.add(val: false, key: .loggedIn)
        
        MyUserDefaults.add(val: "", key: .email)
        MyUserDefaults.add(val: "", key: .username)
        MyUserDefaults.add(val: "", key: .id)
        //        MyUserDefaults.add(val: true, key: .isDisconut)
        
        MyUserDefaults.add(val: "", key: .title)
        MyUserDefaults.add(val: "", key: .city)
        MyUserDefaults.add(val: "", key: .country)
        //        guard let phone = customer.phone else {return}
        MyUserDefaults.add(val: "", key: .phone)
    }
    
    func getCustomerData( onComplete : @escaping (CustomerClass,Int) -> Void , onError: @escaping ()->Void) {
        
        
    remote.getAllUsers(onSuccess: { (allCustomers) in
       guard let customers = allCustomers else {return}
             let email = MyUserDefaults.getValue(forKey: .email) as! String
             
             for i in customers.customers {
                 if email == i.email{
                     onComplete(CustomerClass(firstName: i.firstName, lastName: i.lastName, email: i.email, phone: i.phone, password: i.phone ?? "", verifiedEmail: i.verifiedEmail, addresses: i.addresses),i.id)
                 }
             }
        }) { (error) in
            onError()
        }
        
     

    }
    
    func isLightTheme() -> Bool  {
        return (MyUserDefaults.getValue(forKey: .theme) as! Themes.RawValue) == Themes.light.rawValue
    }
    
    func toggleTheme(){
        let isLight = isLightTheme()
        
        if isLight{
            MyUserDefaults.add(val: Themes.dark.rawValue, key: .theme)
        }else{
            MyUserDefaults.add(val: Themes.light.rawValue, key: .theme)
        }
    }
    
    func isEnglish() -> Bool {
        return MOLHLanguage.currentAppleLanguage() == "en" ? true : false
    }
}
