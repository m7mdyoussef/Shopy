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

protocol MeModelType{
    
    func fetchFavProducts()
    func getUserName() -> String
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
        let localData = FavouritesPersistenceManager.shared
        guard let favourites = localData.retrieveFavourites() else {
            return
        }
        self.favProductsSubject.asObserver().onNext(favourites)
    }
    
    func fetchOrders()  {
        
        loadingSubject.asObserver().onNext(true)
        remote.fetchOrders() { [unowned self] (result) in
            switch result{
            case .success(let response):
                guard let orders = response?.orders else {return}
                print("success")
                self.ordersSubject.asObserver().onNext(getOrdersWithEmail(orders: orders))
                self.loadingSubject.onNext(false)

            case .failure(let error):
                AppCommon.shared.showSwiftMessage(title: "Error", message: error.localizedDescription , theme: .error)
                self.loadingSubject.onNext(false)

            }
            
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
    
    func getUserName() -> String {
        return MyUserDefaults.getValue(forKey: .username) as! String
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
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // api iso format
        if let date = formatter.date(from: date) {
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            return formatter.string(from: date)
        }
        return nil
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
    }
}
