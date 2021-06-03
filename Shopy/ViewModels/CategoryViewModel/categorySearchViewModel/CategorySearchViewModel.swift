//
//  CategorySearchViewModel.swift
//  Shopy
//
//  Created by mohamed youssef on 6/2/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CategorySearchViewModel{
    private var dB = DisposeBag()
    var productElements:[DetailedProducts]!
    private var filteredproductElements:[DetailedProducts]!
    var productsObservable: Observable<[DetailedProducts]>
    private var productsSubject = PublishSubject<[DetailedProducts]>()
    
    var searchWord : BehaviorRelay<String> = BehaviorRelay(value: "")
    private lazy var searchWordObservable:Observable<String> = searchWord.asObservable()
    
    var errorObservable: Observable<Bool>
    var LoadingObservable: Observable<Bool>
    
    private var errorsubject = PublishSubject<Bool>()
    private var Loadingsubject = PublishSubject<Bool>()
    
    private var api:RemoteDataSourceProtocol!

    init() {
        api = RemoteDataSource()
        errorObservable = errorsubject.asObservable()
        LoadingObservable = Loadingsubject.asObservable()
        productsObservable = productsSubject.asObservable()
        filteredproductElements = productElements
        
        searchWordObservable.subscribe(onNext: {[weak self] (value) in
            self?.filteredproductElements = self?.productElements?.filter({ (product) -> Bool in
            product.title.lowercased().contains(value.lowercased())
        })
         if(self?.filteredproductElements != nil){
               if(self!.filteredproductElements!.isEmpty){
                   self?.filteredproductElements = self?.productElements
               }
           }
           self?.productsSubject.onNext(self?.filteredproductElements ?? [])
           }).disposed(by: dB)
    }
        
    func fetchData(){
        Loadingsubject.onNext(true)
        api.getDetailedProducts {[weak self] (result) in
            switch result{
            case .success(let products):
                self?.productElements = products?.products
                self?.filteredproductElements = self?.productElements
                self?.productsSubject.onNext(products?.products ?? [])
                self?.Loadingsubject.onNext(false)
            case .failure(let error):
                self?.Loadingsubject.onNext(false)
                self?.errorsubject.onError(error)
            }
        }
    }
    
    func sortData(index:Int){
        switch index {
        case 0:
            filteredproductElements = productElements.sorted { (product1, product2) -> Bool in
                Double(product1.variants[0].price)! > Double(product2.variants[0].price)!
            }
        default:
            filteredproductElements = productElements.sorted { (product1, product2) -> Bool in
                Double(product1.variants[0].price)! < Double(product2.variants[0].price)!
            }
        }
        productsSubject.onNext(filteredproductElements ?? productElements)
    }
    
    func filterData(word:String){
        filteredproductElements = productElements.filter({ (product) -> Bool in
            product.productType.rawValue.lowercased() == word.lowercased()
            })
        productsSubject.onNext(filteredproductElements)
    }
    
}
