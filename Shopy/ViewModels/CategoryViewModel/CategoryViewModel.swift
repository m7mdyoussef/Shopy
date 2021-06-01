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
    
    //observables
    var mainCatDataObservable: Observable<[CustomElement]>
    var subCatDataObservable: Observable<Set<String>>
    var productDataObservable: Observable<[ProductElement]>

    var errorObservable: Observable<Bool>
    var LoadingObservable: Observable<Bool>
    
    //publishers
    private var data:[ProductElement]?
    private var mainCatDatasubject = PublishSubject<[CustomElement]>()
    private var subCatDatasubject = PublishSubject<Set<String>>()
    private var productDatasubject = PublishSubject<[ProductElement]>()

    private var errorsubject = PublishSubject<Bool>()
    private var Loadingsubject = PublishSubject<Bool>()
    
    var mainCategories = [CustomElement]()
    var subCategories = [ProductElement]()
    var subCategoriesStrings :Set<String> = []
    var filteredProducts = [ProductElement]()
    
    let menTshirt = ["1","2","3"]
    let menShoes = ["4","5","6"]
    let menAcc = ["7","8","9"]
    
    let womenTshirt = ["10","11","12"]
    let womenShoes = ["13","14","15"]
    let womenAcc = ["16","17","18"]
    
    let kidTshirt = ["19","20","21"]
    let kidShoes = ["22","23","24"]
    let kidAcc = ["25","26","27"]

    private var api:RemoteDataSourceProtocol!
    
    init() {
        
        api = RemoteDataSource()
        
        mainCatDataObservable = mainCatDatasubject.asObservable()
        subCatDataObservable = subCatDatasubject.asObservable()
        productDataObservable = productDatasubject.asObservable()

        errorObservable = errorsubject.asObservable()
        LoadingObservable = Loadingsubject.asObservable()
    }
    
    func fetchData() {
        mainCatDatasubject.onNext(mainCategories)
     //   subCatDatasubject.onNext(filteredProducts)
    }
    
    
    func getCollectionData(){
        api.customCollections{[weak self](result) in
           guard let self = self else {return}
            
            switch result {
            case .success(let response):
                guard let customCollections = response?.custom_collections else {return}
                for item in customCollections {
                    self.mainCategories.append(item)
                }
                self.mainCatDatasubject.onNext(self.mainCategories)
                self.fetchCatProducts(collectionId: "\(customCollections[0].id)", subCat: "T-Shirts")
            case .failure(let error):
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
        
    }
    
    
func fetchCatProducts(collectionId:String,subCat:String){
    Loadingsubject.onNext(true)
    print(collectionId + " " + subCat)
    api.getProducts(collectionId: collectionId){[weak self] (result) in
        guard let self = self else  {return}
        switch result{
        case .success(let cat):
            guard let subCategories = cat?.products else {return}
            self.subCategories = subCategories
            for sub in subCategories{
                self.subCategoriesStrings.insert(sub.productType)
            }
            
            self.subCatDatasubject.onNext(self.subCategoriesStrings)
//            self?.fetchFilteredProducts(subCat: subCat)
//            let filteredData = self?.subCategories?.filter({(catItem) -> Bool in
//                catItem.productType.capitalized == subCat.capitalized
//            })
//            self?.productDatasubject.onNext(filteredData ?? [])
//            self?.Loadingsubject.onNext(false)
        case .failure(let error):
            self.Loadingsubject.onNext(false)
            self.errorsubject.onError(error)
        }
    }
}
    
    
    
    
func fetchFilteredProducts(subCat:String){
    filteredProducts.removeAll()
    for product in subCategories {
        if product.productType == subCat {
            filteredProducts.append(product)
        }
    }
    self.productDatasubject.onNext(filteredProducts)
    self.Loadingsubject.onNext(false)
}
    
    
    
    
    
    
    
    
//    func fetchCatProducts(mainCat:String,subCat:String){
//        Loadingsubject.onNext(true)
//        print(mainCat + " " + subCat)
//         api.getCategoryProducts(catType: mainCat) {[weak self] (result) in
//            switch result{
//            case .success(let cat):
//                self?.data = cat?.products
//                let filteredData = self?.data?.filter({(catItem) -> Bool in
//                    catItem.productType.capitalized == subCat.capitalized
//                })
//                self?.productDatasubject.onNext(filteredData ?? [])
//                self?.Loadingsubject.onNext(false)
//            case .failure(let error):
//                self?.Loadingsubject.onNext(false)
//                self?.errorsubject.onError(error)
//            }
//        }
//    }
    
}
