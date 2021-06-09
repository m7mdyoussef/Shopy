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
    
    var favProductsObservable: Driver<[FavouriteProduct]>?{get}
    var ordersObservable: Driver<[Order]>?{get}
    var loadingObservable: Driver<Bool>{get}
}

class MeTapViewModel:MeModelType {

    var favProductsObservable: Driver<[FavouriteProduct]>?
    var ordersObservable: Driver<[Order]>?
    var loadingObservable: Driver<Bool>
    
    private var favProductsSubject = PublishSubject<[FavouriteProduct]>()
    private var ordersSubject = PublishSubject<[Order]>()
    private var loadingSubject = PublishSubject<Bool>()
    
    var remote:RemoteDataSource!

    init() {
        favProductsObservable = favProductsSubject.asDriver(onErrorJustReturn: [])
        ordersObservable = ordersSubject.asDriver(onErrorJustReturn: [])
        loadingObservable = loadingSubject.asDriver(onErrorJustReturn: true)
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
        
        loadingSubject.asObserver().onNext(true)
        remote.fetchOrders(financialStatus: status) { [unowned self] (result) in
            switch result{
            case .success(let response):
                guard let orders = response?.orders else {return}
                print("success")
                ordersSubject.asObserver().onNext(orders)
                loadingSubject.onNext(false)

            case .failure(let error):
                AppCommon.shared.showSwiftMessage(title: "Error", message: error.localizedDescription , theme: .error)
                loadingSubject.onNext(false)

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
