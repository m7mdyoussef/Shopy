//
//  BagViewModel.swift
//  Shopy
//
//  Created by Amin on 10/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
protocol BagViewModelType {
    var loading: Driver<Bool>{get}
    var error: Driver<Bool>{get}
}

class BagViewModel: BagViewModelType {
    var loading: Driver<Bool>
    var error: Driver<Bool>
    let remote : RemoteDataSource!
    
    private var loadingSubject = PublishSubject<Bool>()
    private var errorSubject = PublishSubject<Bool>()
    init() {
        remote = RemoteDataSource()
        loading = loadingSubject.asDriver(onErrorJustReturn: false)
        error = errorSubject.asDriver(onErrorJustReturn: false)
    }
    
    func checkout(product: [BagProduct]) {
        
        let email = MyUserDefaults.getValue(forKey: .email) as! String
        let order = PostOrder(email: email, fulfillmentStatus: "fulfilled", lineItems: retreiveLineItems(products: product))

        let postOrder = PostOrderRequest(order: order)
        loadingSubject.asObserver().onNext(true)
        remote.postOrder(order: postOrder) { [weak self] (data) in
            guard let self = self else {return}
            self.loadingSubject.asObserver().onNext(false)
            do{
                let _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                print(String(decoding: data, as: UTF8.self))
            }catch{
                self.errorSubject.asObserver().onNext(true)
            }
            
        } onFailure: { (err) in
            self.errorSubject.asObserver().onNext(true)
        }
    }
    
    private func retreiveLineItems(products: [BagProduct]) -> [PostLineItem]{
        var array = [PostLineItem]()
        for product in products{
            array.append(PostLineItem(variantID: Int(product.variantId), quantity: Int(product.count)))
        }
        return array
    }
}
