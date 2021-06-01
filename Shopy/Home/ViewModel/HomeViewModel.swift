//
//  HomeViewModel.swift
//  Shopy
//
//  Created by SOHA on 5/30/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeModelType{
    func getCollectionData()
    func getAllProduct(id:String)
    var collectionDataObservable : Observable<[CustomElement]>?{get}
//    var collectionErrorObservable : PublishSubject<Error>?{get}
    var productsDataObservable : Observable<[ProductElement]>?{get}
//    var productsErrorObservable : PublishSubject<Error>?{get}

}

class HomeViewModel: HomeModelType{
    var productsDataObservable: Observable<[ProductElement]>?
    
    let api = RemoteDataSource()
    var collectionDataObservable : Observable<[CustomElement]>?
    private var collectionDataSubject = PublishSubject<[CustomElement]>()
    private var productDataSubject = PublishSubject<[ProductElement]>()
    
    init() {
        collectionDataObservable = collectionDataSubject.asObserver()
        productsDataObservable  = productDataSubject.asObservable()
    }
    
    func getCollectionData(){
        api.customCollections{[weak self](result) in
           guard let self = self else {return}
            
            switch result {
            case .success(let response):
                guard let customCollections = response?.custom_collections else {return}
                self.collectionDataSubject.asObserver().onNext(customCollections)
               //self.getAllProduct(id: String(customCollections[0].id))
                
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
        
    }
    func getAllProduct(id:String){
        api.getProducts(collectionId: id){[weak self](result) in
           guard let self = self else {return}

            switch result {
            case .success(let response):
                guard let products = response?.products else {return}
                self.productDataSubject.asObserver().onNext(products)
                print(products[0].productType)
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
    }
}
