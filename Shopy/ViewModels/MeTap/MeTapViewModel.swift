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
    func fetchOrders(status: FinancialStatus)
    
    var favProducts: Driver<[FavouriteProduct]>?{get}
    var orders: Driver<[Order]>?{get}
}

class MeTapViewModel:MeModelType {

    var favProducts: Driver<[FavouriteProduct]>?
    var orders: Driver<[Order]>?
    
    private var favProductsSubject = PublishSubject<[FavouriteProduct]>()
    private var ordersSubject = PublishSubject<[Order]>()
    
    
    var remote:RemoteDataSource!

    init() {
        favProducts = favProductsSubject.asDriver(onErrorJustReturn: [])
        orders = ordersSubject.asDriver(onErrorJustReturn: [])
        remote = RemoteDataSource()
    }
    
    func fetchFavProducts() {
        let localData = FavouritesPersistenceManager.shared
        guard let favourites = localData.retrieveFavourites() else {
            return
        }
        self.favProductsSubject.asObserver().onNext(favourites)
    }
    
    func fetchOrders(status: FinancialStatus)  {
        remote.fetchOrders(financialStatus: status) { [unowned self] (result) in
            
            switch result{
            case .success(let response):
                guard let orders = response?.orders else {return}
                print("success")
                self.ordersSubject.asObserver().onNext(orders)
//                self.Loadingsubject.onNext(false)

            case .failure(let error):
                AppCommon.shared.showSwiftMessage(title: "Error", message: error.localizedDescription , theme: .error)
//                self.Loadingsubject.onNext(false)

            }
            
        }
    }
    
    
    func isUserLoggedIn() -> Bool {
        let value = MyUserDefaults.getValue(forKey: .loggedIn)
        guard let isLoggedIn = value else {return false}
        
        return (isLoggedIn as! Bool) ? true : false
    }
    
    func getUserName() -> String {
        return MyUserDefaults.getValue(forKey: .username) as! String
    }
    
}
