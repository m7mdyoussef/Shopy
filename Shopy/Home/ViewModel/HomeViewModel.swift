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
    func getProductElement(idProduct:String)
    var collectionDataObservable : Observable<[CustomElement]>?{get}
    var productsDataObservable : Observable<[ProductElement]>?{get}
    var productElementObservable : Observable<ProductClass>?{get}
    var productElementErrorObservable : PublishSubject<String>?{get}
    var collectionErrorObservable : PublishSubject<String>?{get}
    var productsErrorObservable : PublishSubject<String>?{get}
}

class HomeViewModel: HomeModelType{
   
    let api = RemoteDataSource()
    var collectionDataObservable : Observable<[CustomElement]>?
    var productsDataObservable: Observable<[ProductElement]>?
    var collectionErrorObservable: PublishSubject<String>?
    var productsErrorObservable: PublishSubject<String>?
    var productElementErrorObservable: PublishSubject<String>?
    var productElementObservable: Observable<ProductClass>?
    
    private var collectionDataSubject = PublishSubject<[CustomElement]>()
    private var productDataSubject = PublishSubject<[ProductElement]>()
    private var productElementDataSubject = PublishSubject<ProductClass>()
    private var collectionErrorSubject = PublishSubject<String>()
    private var productsErrorSubject = PublishSubject<String>()
    private var productElementErrorSubject = PublishSubject<String>()
   
    
    init() {
        collectionDataObservable = collectionDataSubject.asObserver()
        productsDataObservable  = productDataSubject.asObservable()
        productElementObservable = productElementDataSubject.asObserver()
        collectionErrorObservable = collectionErrorSubject.asObserver()
        productsErrorObservable = productsErrorSubject.asObserver()
        productElementErrorObservable = productElementErrorSubject.asObserver()
        
        
    }
    
    func getCollectionData(){
        api.customCollections{[weak self](result) in
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                guard let customCollections = response?.custom_collections else {return}
                self.collectionDataSubject.asObserver().onNext(customCollections)
                self.getAllProduct(id: String(customCollections[0].id))
            case .failure(let error):
                self.collectionErrorSubject.asObserver().onNext(error.localizedDescription)
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
            case .failure(let error):
                self.productsErrorSubject.asObserver().onNext(error.localizedDescription)
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
    }
    
    func getProductElement(idProduct:String){
        api.getProductElement(productId: idProduct) {[weak self] (result) in
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                guard let product = response?.product else {return}
                self.productElementDataSubject.asObserver().onNext(product)
                print(product.title)
            
            case .failure(let error):
                self.productElementErrorSubject.asObserver().onNext(error.localizedDescription)
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
    }
    
}
