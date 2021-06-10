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


class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var productDetails: UITextView!
    @IBOutlet weak var productPrice: UILabel!
    var showIndicator: ShowIndecator?
    var homeViewModel : HomeModelType?
    var frame = CGRect.zero
    var disposeBag = DisposeBag()
    var idProduct = ""
    var arrOption = BehaviorRelay(value: [""])
    let manager = FavouritesPersistenceManager.shared
    let bagManager = BagPersistenceManager.shared
    var productElement : ProductClass?
    var isFavo: Bool?
    var imagesArr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        slideShow.pageIndicator = pageIndicator
        slideShow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .left(padding: 20), vertical: .bottom)
        
        showIndicator = ShowIndecator(view: view.self)
        homeViewModel = HomeViewModel()
        setupScreens()
       
        registerSizeCell()
        sizeCollectionView.rx.setDelegate(self)
        cardButton.layer.cornerRadius = 25
        arrOption.asObservable().bind(to: sizeCollectionView.rx.items(cellIdentifier: "SizesCollectionViewCell")){row, items, cell in
            (cell as? SizesCollectionViewCell)?.productSize.text = String(items)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        checkColor()
    }
   
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
       
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    @IBAction func addToWishList(_ sender: Any) {
        self.isFavo = self.manager.isFavourited(productID: productElement?.id ?? 0)
        checkFav()
    }
    @IBAction func addToCard(_ sender: Any) {
       let isStored = bagManager.isBagProduct(productID: productElement!.id)
        if isStored {
            self.presentGFAlertOnMainThread(title: "Success", message: "This product is already in card", buttonTitle: "OK")
        }else{
            self.presentGFAlertOnMainThread(title: "Success", message: "Successfully added to the card🎉🎉", buttonTitle: "OK")
            bagManager.addToBagProducts(bagProduct: productElement!)
        }
        
       // onSuccessHud()
    }
    
    func setupScreens(){
        showIndicator?.startAnimating()
        homeViewModel?.getProductElement(idProduct: idProduct ?? "")
        homeViewModel?.productElementObservable?.asObservable().subscribe{[weak self]response in
            guard let self = self else {return}
            self.productElement = response.element
            print(response.element?.id)
            self.productTitle.text = response.element?.title
            self.productPrice.text = response.element?.variants[0].price
            self.productDetails.text = response.element?.bodyHTML
            self.isFavo = self.manager.isFavourited(productID: response.element?.id ?? 0)
            self.checkColor()
            self.arrOption.accept(((response.element?.options[0].values) ?? []))
            var imgs = response.element?.images
            self.slideShow.slideshowInterval = 3.0
            self.slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
            self.slideShow.contentScaleMode = UIViewContentMode.scaleAspectFit

            self.slideShow.activityIndicator = DefaultActivityIndicator()
            self.slideShow.delegate = self
            
            var arr = [InputSource]()
            for index in 0..<(imgs?.count)! {
                arr.append(SDWebImageSource(url: URL(string: (imgs?[index].src)!)!) as! InputSource)
                
            }
            self.slideShow.setImageInputs(arr)
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProductDetailsViewController.didTap))
            self.slideShow.addGestureRecognizer(recognizer)
            self.showIndicator?.stopAnimating()
            
       }.disposed(by: disposeBag)
    }
    
    func checkColor(){
        if self.isFavo == true{
            self.favouriteButton.tintColor = UIColor.red
        }else{
            self.favouriteButton.tintColor = UIColor.gray
        }
    }
}

extension ProductDetailsViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
      //  print("current page:", page)
    }
}
