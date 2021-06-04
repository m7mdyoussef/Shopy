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
    private var productElements:[DetailedProducts]!
    private var filteredproductElements:[DetailedProducts]!
    private var sortedproductElements:[DetailedProducts]!
    private var searchedproductElements:[DetailedProducts]!
    private var isSorted:Bool = false
    private var isfiltered:Bool = false
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
        searchedproductElements = productElements
        //sortedproductElements = productElements
        
        searchWordObservable.subscribe(onNext: {[weak self] (value) in
            self?.searchedproductElements = self?.productElements?.filter({ (product) -> Bool in
            product.title.lowercased().contains(value.lowercased())
        })
            if(value.isEmpty){
                 self?.isfiltered = false
                 self?.isSorted = false
                 self?.searchedproductElements = self?.productElements
             }
           self?.productsSubject.onNext(self?.searchedproductElements ?? [])
           }).disposed(by: dB)
    }
        
    func fetchData(){
        Loadingsubject.onNext(true)
        api.getDetailedProducts {[weak self] (result) in
            switch result{
            case .success(let products):
                self?.productElements = products?.products
                
                self?.searchedproductElements = self?.productElements
                self?.sortedproductElements = self?.productElements
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
        
        isSorted = true
                if(isfiltered){
                    switch index {
                    case 0:
                        sortedproductElements = filteredproductElements.sorted { (product1, product2) -> Bool in
                            Double(product1.variants[0].price)! > Double(product2.variants[0].price)!
                        }
                    default:
                        sortedproductElements = filteredproductElements.sorted { (product1, product2) -> Bool in
                            Double(product1.variants[0].price)! < Double(product2.variants[0].price)!
                        }
                    }
                    }else{
                          switch index {
                          case 0:
                              sortedproductElements = searchedproductElements.sorted { (product1, product2) -> Bool in
                                  Double(product1.variants[0].price)! > Double(product2.variants[0].price)!
                              }
                          default:
                              sortedproductElements = searchedproductElements.sorted { (product1, product2) -> Bool in
                                  Double(product1.variants[0].price)! < Double(product2.variants[0].price)!
                              }
                          }
                      }
        productsSubject.onNext(sortedproductElements)
    }
    
    func filterData(word:String){
         isfiltered = true
         if(isSorted){
             filteredproductElements = sortedproductElements.filter({ (product) -> Bool in
             product.productType.rawValue.lowercased() == word.lowercased()
             })
         }else{
             filteredproductElements = searchedproductElements.filter({ (product) -> Bool in
             product.productType.rawValue.lowercased() == word.lowercased()
             })
         }
         productsSubject.onNext(filteredproductElements)
     }

     func clearData(){
         productsSubject.onNext(productElements)
         self.searchedproductElements = self.productElements
         self.sortedproductElements = self.productElements
         self.filteredproductElements = self.productElements
         isfiltered = false
         isSorted = false
     }
    
}
