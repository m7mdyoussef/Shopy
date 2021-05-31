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
    func getAllProduct()
    var collectionDataObservable : Observable<[CustomElement]>?{get}
//    var collectionErrorObservable : PublishSubject<Error>?{get}
//    var productsDataObservable : Observable<[CustomElement]>?{get}
//    var productsErrorObservable : PublishSubject<Error>?{get}

}

class HomeViewModel: HomeModelType{
    let api = RemoteDataSource()
    var collectionDataObservable : Observable<[CustomElement]>?
    private var collectionDataSubject = PublishSubject<[CustomElement]>()
    
    init() {
        collectionDataObservable = collectionDataSubject.asObserver()
    }
    
    func getCollectionData(){
        api.customCollections{[weak self](result) in
           guard let self = self else {return}
            
            switch result {
            case .success(let response):
                guard let customCollections = response?.custom_collections else {return}
                self.collectionDataSubject.asObserver().onNext(customCollections)
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
        
    }
    func getAllProduct(){
        api.getProducts(collectionId: "268359631046"){[weak self](result) in
           guard let self = self else {return}

            switch result {
            case .success(let response):
                guard let products = response?.products else {return}
              //  self.collectionDataSubject.asObserver().onNext(customCollections)
                print(products[0].productType)
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
    }
}
