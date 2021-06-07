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
    var favProducts: Driver<[FavouriteProduct]>?{get}
}

class MeTapViewModel:MeModelType {
    //    var favProducts: [FavouriteProduct]! {
    //        didSet{
    //            resetViews()
    //        }
    //    }
    var favProducts: Driver<[FavouriteProduct]>?
    
    private var favProductsSubject = PublishSubject<[FavouriteProduct]>()
    
    init() {
        favProducts = favProductsSubject.asDriver(onErrorJustReturn: [])
    }
    
    func fetchFavProducts() {
        let localData = FavouritesPersistenceManager.shared
        guard let favourites = localData.retrieveFavourites() else {
            return
        }
        self.favProductsSubject.asObserver().onNext(favourites)
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
