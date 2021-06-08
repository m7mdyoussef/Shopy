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
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var productPrice: UILabel!
    var showIndicator: ShowIndecator?
    var homeViewModel : HomeModelType?
    var frame = CGRect.zero
    var disposeBag = DisposeBag()
    var idProduct = ""
    var arrOption = BehaviorRelay(value: [""])
    let manager = FavouritesPersistenceManager.shared
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
       // detailsView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        setupScreens()
     //   imageScrollView.delegate = self
       
        registerSizeCell()
        sizeCollectionView.rx.setDelegate(self)
        cardButton.roundCorners(corners: .allCorners, radius: 25)
        arrOption.asObservable().bind(to: sizeCollectionView.rx.items(cellIdentifier: "SizesCollectionViewCell")){row, items, cell in
            (cell as? SizesCollectionViewCell)?.productSize.text = String(items)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        checkColor()
    }
    
    
   
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    @IBAction func addToWishList(_ sender: Any) {
        self.isFavo = self.manager.isFavourited(productID: productElement?.id ?? 0)
        checkFav()
        //   manager.addToBagProducts(bagProduct: self.productElement!)
    }
    @IBAction func addToCard(_ sender: Any) {
        let vc = FavouriteProductsVC()
        self.navigationController?.pushViewController(vc, animated: true)
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
            self.slideShow.slideshowInterval = 5.0
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
            
            
            
            


            
            
         //   slideshow.setImageInputs(imag)
//            self.pageControl.numberOfPages = imgs?.count ?? 0
//            for index in 0..<(imgs?.count)! {
//                self.frame.origin.x = self.imageScrollView.frame.size.width * CGFloat(index)
//                self.frame.size = self.imageScrollView.frame.size
//                let imgView = UIImageView(frame: self.frame)
//                imgView.sd_setImage(with: URL(string: (imgs?[index].src)!), completed: nil)
//                self.imageScrollView.addSubview(imgView)
 //           }
            
//            self.imageScrollView.contentSize = CGSize(width: (self.imageScrollView.frame.size.width * CGFloat(imgs!.count)), height: self.imageScrollView.frame.size.height)
//            self.imageScrollView.delegate = self
//            self.showIndicator?.stopAnimating()
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

extension ProductDetailsViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      //  let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
      //  pageControl.currentPage = Int(pageNumber)
    }
}

extension ProductDetailsViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
      //  print("current page:", page)
    }
}
