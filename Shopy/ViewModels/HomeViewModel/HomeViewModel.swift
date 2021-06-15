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
import AVFoundation

protocol HomeModelType{
    func getCollectionData()
    func getAllProduct(id:String)
    func getProductElement(idProduct:String)
    func getPriceRules()
    func getDiscountCode(priceRule:String)
    var collectionDataObservable : Observable<[CustomElement]>?{get}
    var productsDataObservable : Observable<[ProductElement]>?{get}
    var productElementObservable : Observable<ProductClass>?{get}
    var priceRuleObservable: Observable<[PriceRule]>?{get}
    var discontCodeObservable: Observable<[DiscountCodeElement]>?{get}
    var LoadingObservable: Observable<Bool>?{get}
}

class HomeViewModel: HomeModelType,ICanLogin{
    var LoadingObservable: Observable<Bool>?
        
    var ProductElements:[ProductElement]?
    let api = RemoteDataSource()
    var collectionDataObservable : Observable<[CustomElement]>?
    var productsDataObservable: Observable<[ProductElement]>?
    var productElementObservable: Observable<ProductClass>?
    var priceRuleObservable: Observable<[PriceRule]>?
    var discontCodeObservable: Observable<[DiscountCodeElement]>?
    var mainCategoryObservable : Observable<[String]>?
    private var collectionDataSubject = PublishSubject<[CustomElement]>()
    private var productDataSubject = PublishSubject<[ProductElement]>()
    private var productElementDataSubject = PublishSubject<ProductClass>()
    private var PriceRuleDataSubject = PublishSubject<[PriceRule]>()
    private var discountCodeDataSubject = PublishSubject<[DiscountCodeElement]>()
    private var Loadingsubject = PublishSubject<Bool>()
    private var dispatchGroup : DispatchGroup!

    
    init() {
        mainCategoryObservable = Observable.just(["Men".localized, "Women".localized , "Kids".localized])
        collectionDataObservable = collectionDataSubject.asObserver()
        productsDataObservable  = productDataSubject.asObservable()
        productElementObservable = productElementDataSubject.asObserver()
        priceRuleObservable = PriceRuleDataSubject.asObserver()
        discontCodeObservable = discountCodeDataSubject.asObserver()
        LoadingObservable = Loadingsubject.asObservable()
        dispatchGroup = DispatchGroup()

    }
    
    func getCollectionData(){
        Loadingsubject.onNext(true)
        dispatchGroup.enter()
        api.customCollections{[weak self](result) in
            guard let self = self else {return}
            self.dispatchGroup.leave()
            switch result {
            case .success(let response):
                guard let customCollections = response?.custom_collections else {return}
                self.collectionDataSubject.asObserver().onNext(customCollections)
                self.getAllProduct(id: String(customCollections[2].id))
            case .failure(let error):
                AppCommon.shared.showSwiftMessage(title: "Error", message: error.localizedDescription , theme: .error)
                self.Loadingsubject.onNext(false)
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
    }
    
    func getAllProduct(id:String){
        Loadingsubject.onNext(true)
        dispatchGroup.enter()
        api.getProducts(collectionId: id){[weak self](result) in
            guard let self = self else {return}
            self.dispatchGroup.leave()
            switch result {
            case .success(let response):
                guard let products = response?.products else {return}
                self.productDataSubject.asObserver().onNext(products)
                self.ProductElements = products
            case .failure(let error):
                AppCommon.shared.showSwiftMessage(title: "Error".localized, message: error.localizedDescription , theme: .error)
                self.Loadingsubject.onNext(false)
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
    }
    
    func getProductElement(idProduct:String){
        Loadingsubject.onNext(true)
        api.getProductElement(productId: idProduct) {[weak self] (result) in
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                guard let product = response?.product else {return}
                self.productElementDataSubject.asObserver().onNext(product)
                print(product.title)
                self.Loadingsubject.onNext(false)
            case .failure(let error):
                AppCommon.shared.showSwiftMessage(title: "Error".localized, message: error.localizedDescription , theme: .error)
                self.Loadingsubject.onNext(false)
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
    }
    
    func getPriceRules(){
        Loadingsubject.onNext(true)
        dispatchGroup.enter()
        api.getPriceRules{[weak self](result) in
            guard let self = self else {return}
            self.dispatchGroup.leave()
            switch result {
            case .success(let response):
                guard let priceRules = response?.priceRules else {return}
                self.PriceRuleDataSubject.asObserver().onNext(priceRules)
                print(priceRules[0].id)
            case .failure(let error):
                AppCommon.shared.showSwiftMessage(title: "Error".localized, message: error.localizedDescription , theme: .error)
                self.Loadingsubject.onNext(false)
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
    }
    
    func getDiscountCode(priceRule:String){
        Loadingsubject.onNext(true)
        dispatchGroup.enter()
        api.getDiscountCode(priceRule: priceRule){[weak self](result) in
            guard let self = self else {return}
            self.dispatchGroup.leave()
            switch result {
            case .success(let response):
                guard let discountCode = response?.discountCodes else {return}
                self.discountCodeDataSubject.asObserver().onNext(discountCode)
                print(discountCode[0].code)
            case .failure(let error):
                AppCommon.shared.showSwiftMessage(title: "Error".localized, message: error.localizedDescription , theme: .error)
                print(error.userInfo[NSLocalizedDescriptionKey] as? String ?? "")
                print(error.code)
            }
        }
        dispatchGroup.notify(queue:.main) { [weak self] in
            guard let self = self else {return}
            self.Loadingsubject.onNext(false)
        }
    }
   
    var bombSoundEffect: AVAudioPlayer?
    func playWow()  {
        
        guard let path = Bundle.main.path(forResource: "Wow", ofType: "mp3") else {return}
        let url = URL(fileURLWithPath: path)

        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
        } catch(let err) {
            print("could load \(err)")
        }

    }
    
//    func playWow() {
//
//        guard let url = Bundle.main.url(forResource: "Wow", withExtension: "mp3") else { return }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            /* iOS 10 and earlier require the following line:
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//
//            guard let player = player else { return }
//
//            player.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
    
    func saveDiscountCode(code: String) {
        MyUserDefaults.add(val: code, key: .discountCode)
    }
}
