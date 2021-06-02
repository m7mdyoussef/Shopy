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
    var productElements:[ProductElement]!
    var productsObservable: Observable<[ProductElement]>
    private var productsSubject = PublishSubject<[ProductElement]>()
    
    var searchWord : BehaviorRelay<String> = BehaviorRelay(value: "")
    private lazy var searchWordObservable:Observable<String> = searchWord.asObservable()
    
    init(products:[ProductElement]) {
        self.productElements = products
        productsObservable = productsSubject.asObservable()
        searchWordObservable.subscribe(onNext: {[weak self] (value) in
        let searchedProduct = self?.productElements?.filter({ (product) -> Bool in
            product.title.lowercased().prefix(value.count) == value.lowercased()
        })
        self?.productsSubject.onNext(searchedProduct ?? [])
        }).disposed(by: dB)
    }
    
    func fetchData(){
        productsSubject.onNext(productElements)
    }
    
}
