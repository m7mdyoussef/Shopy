//
//  ProductDetailsViewController.swift
//  Shopy
//
//  Created by SOHA on 6/1/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import SDWebImage
import RxCocoa
import RxSwift
import ImageSlideshow
import JGProgressHUD
import ReadMoreTextView

class ProductDetailsViewController: UIViewController, ICanLogin{
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var productDetails: UITextView!
    @IBOutlet weak var productPrice: UILabel!
    var homeViewModel : HomeModelType?
    var frame = CGRect.zero
    var disposeBag = DisposeBag()
    var idProduct = ""
    var arrOption = BehaviorRelay(value: [""])
    let manager = FavouritesPersistenceManager.shared
    let bagManager = BagPersistenceManager.shared
    var productElement : ProductClass?
    var isFavo: Bool = false
    var imagesArr = [String]()
    var sizeProduct = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        slideShow.pageIndicator = pageIndicator
        slideShow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .left(padding: 20), vertical: .bottom)
        homeViewModel = HomeViewModel()
        setupScreens()
        registerSizeCell()
        showLoading()
        sizeCollectionView.rx.setDelegate(self)
        cardButton.layer.cornerRadius = 25
        setUpSizeCollection()
        
//        productDetails.shouldTrim = true
//        productDetails.maximumNumberOfLines = 4
//        productDetails.attributedReadMoreText = NSAttributedString(string: "... Read more")
//        productDetails.attributedReadLessText = NSAttributedString(string: " Read less")
    }
    
    func setUpSizeCollection(){
        arrOption.asObservable().bind(to: sizeCollectionView.rx.items(cellIdentifier: "SizesCollectionViewCell")){row, items, cell in
            (cell as? SizesCollectionViewCell)?.productSize.text = String(items)
        }
        
        sizeCollectionView.rx.modelSelected(String.self).subscribe{ [weak self] value in
            guard let self = self else {return}
            print(value.element!)
            self.sizeProduct = value.element ?? ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkColor()
        tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func addToWishList(_ sender: Any) {
        if isUserLoggedIn(){
            self.isFavo = self.manager.isFavourited(productID: productElement?.id ?? 0)
            checkFav()
        }
        else{
            self.presentGFAlertOnMainThread(title: "Warning !!", message: "Please,login first", buttonTitle: "OK")
        }
        
    }
    
    @IBAction func addToCard(_ sender: Any) {
        if isUserLoggedIn(){
            if(sizeProduct == ""){
                self.presentGFAlertOnMainThread(title: "Warning !!", message: "Please, Choose your size.", buttonTitle: "OK")
            }else{
            let isStored = bagManager.isBagProduct(productID: productElement!.id)
            if isStored {
                self.presentGFAlertOnMainThread(title: "Warning !!", message: "This product is already in card", buttonTitle: "OK")
            }else{
                self.presentGFAlertOnMainThread(title: "Success", message: "Successfully added to the card🎉🎉", buttonTitle: "OK")
                bagManager.addToBagProducts(bagProduct: productElement!, size: sizeProduct)
            }
            }
        }
        else{
            self.presentGFAlertOnMainThread(title: "Warning !!", message: "Please,login first", buttonTitle: "OK")
        }
        
    }
    
    func checkColor(){
        if isUserLoggedIn(){
            if self.isFavo == true{
                self.favouriteButton.tintColor = UIColor.red
            }else{
                self.favouriteButton.tintColor = UIColor.gray
            }
        }
        else{
            self.favouriteButton.tintColor = UIColor.gray
        }
    }
    
    func showLoading(){
        homeViewModel?.LoadingObservable?.subscribe(onNext: {[weak self] (value) in
            let hud = JGProgressHUD()
            hud.textLabel.text = "Loading"
            hud.style = .dark
            hud.show(in: (self?.view)!)
            switch value{
            case true:
                hud.dismiss()
            case false:
                hud.dismiss()
            }
        }).disposed(by: disposeBag)
        
    }
}

extension ProductDetailsViewController: ImageSlideshowDelegate {
    
    func setupScreens(){
        homeViewModel?.getProductElement(idProduct: idProduct )
        homeViewModel?.productElementObservable?.asObservable().subscribe{[weak self]response in
            guard let self = self else {return}
            self.productElement = response.element
            self.productTitle.text = response.element?.title
            self.productPrice.text = response.element?.variants[0].price
            self.productDetails.text = response.element?.bodyHTML
            if self.isUserLoggedIn(){
                self.isFavo = self.manager.isFavourited(productID: response.element?.id ?? 0)
            }
            self.checkColor()
            self.arrOption.accept(((response.element?.options[0].values) ?? []))
            let imgs = response.element?.images
            self.slideShow.slideshowInterval = 2.0
            self.slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
            self.slideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            self.slideShow.activityIndicator = DefaultActivityIndicator()
            self.slideShow.delegate = self
            var arr = [InputSource]()
            for index in 0..<(imgs?.count)! {
                arr.append(SDWebImageSource(url: URL(string: (imgs?[index].src)!)!) as InputSource)
            }
            self.slideShow.setImageInputs(arr)
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProductDetailsViewController.didTap))
            self.slideShow.addGestureRecognizer(recognizer)
            
        }.disposed(by: disposeBag)
    }
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
