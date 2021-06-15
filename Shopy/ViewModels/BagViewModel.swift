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
import AVFoundation

enum CheckoutStatus:String {
    case pending = "pending"
    case paid = "paid"
}

protocol BagViewModelType {
    var loading: Driver<Bool>{get}
    var error: Driver<Bool>{get}
}

class BagViewModel: BagViewModelType,ICanLogin {
    
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
    
    func checkout(product: [BagProduct],status:CheckoutStatus) {
        

        let id = MyUserDefaults.getValue(forKey: .id) as! Int
        
        
        var code: [Code] = []
        if  (MyUserDefaults.getValue(forKey: .isDisconut) as? Bool)! {
            code = [Code(code:MyUserDefaults.getValue(forKey: .discountCode) as! String)]
        }
        
        
//        let order = PostNewOrder(lineItems: retreiveLineItems(products: product), customer: MyCustomer(id: id), financialStatus: status.rawValue, discountCode: code)
        
        let order = PostNewOrder(lineItems: retreiveLineItems(products: product), customer: MyCustomer(id: id), financialStatus: status.rawValue, discountCode: code)
        
        let postOrder = PostOrderRequest(order: order)
    
        loadingSubject.asObserver().onNext(true)
        
        remote.postOrder(order: postOrder, onCompletion: { [weak self] (data) in
         guard let self = self else {return}
           self.loadingSubject.asObserver().onNext(false)
           do{
               let _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
               print(String(decoding: data, as: UTF8.self))
           }catch{
               self.errorSubject.asObserver().onNext(true)
           }
        }) { (err) in
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
    
    var bombSoundEffect: AVAudioPlayer?
    func playPaidSound()  {
        
        guard let path = Bundle.main.path(forResource: "Cash", ofType: "mp3") else {return}
        let url = URL(fileURLWithPath: path)

        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
        } catch(let err) {
            print("could load \(err)")
        }

    }
}
