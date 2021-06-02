//
//  CategoryViewModel.swift
//  Shopy
//
//  Created by mohamed youssef on 5/30/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import RxSwift

class CategoryViewModel : CategoryContract{
    let mainCategoryElements = ["Men","Women","Kids"]
    let subCategoryElements = ["T-Shirts","Shoes","Accessories"]
    var ProductElements:[ProductElement]?
    //observables
    var errorObservable: Observable<Bool>
    var LoadingObservable: Observable<Bool>
    var mainCategoryElementsObservable: Observable<[String]>
    var subCategoryElementsObservable: Observable<[String]>
    var productsObservable: Observable<[ProductElement]>
    //publishers
    private var errorsubject = PublishSubject<Bool>()
    private var Loadingsubject = PublishSubject<Bool>()
    private var mainCategoryElementsSubject = PublishSubject<[String]>()
    private var subCategoryElementsSubject = PublishSubject<[String]>()
    private var productsSubject = PublishSubject<[ProductElement]>()

    private var api:RemoteDataSourceProtocol!
    
    init() {
        
        api = RemoteDataSource()
        errorObservable = errorsubject.asObservable()
        LoadingObservable = Loadingsubject.asObservable()
        mainCategoryElementsObservable = mainCategoryElementsSubject.asObservable()
        subCategoryElementsObservable = subCategoryElementsSubject.asObservable()
        productsObservable = productsSubject.asObservable()

    }
    
    func fetchData() {
        mainCategoryElementsSubject.onNext(mainCategoryElements)
        subCategoryElementsSubject.onNext(subCategoryElements)
    }
    
    func fetchFilterdProducts(mainCategoryElement:String,subCategoryElement:String){
        Loadingsubject.onNext(true)
        api.getCategoryProducts(categoryType: mainCategoryElement) {[weak self] (response) in
            switch response{
            case .success(let category):
                self?.ProductElements = category?.products
                let filteredProducts = self?.ProductElements?.filter({(categor) -> Bool in
                    categor.productType.capitalized == subCategoryElement.capitalized
                })
                self?.productsSubject.onNext(filteredProducts ?? [])
                self?.ProductElements = filteredProducts
                self?.Loadingsubject.onNext(false)
            case .failure(let error):
                self?.Loadingsubject.onNext(false)
                self?.errorsubject.onError(error)
            }
        }
    }
    
}
