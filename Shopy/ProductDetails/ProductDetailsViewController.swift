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

class ProductDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var homeViewModel : HomeModelType?
    var frame = CGRect.zero
    var disposeBag = DisposeBag()
    var idProduct = ""
    var idCollection = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel = HomeViewModel()
        
        setupScreens()
        imageScrollView.delegate = self
//        homeViewModel?.getCollectionData()
//        homeViewModel?.getAllProduct(id: idCollection)
        
        
        
    }
    
    func setupScreens(){
        homeViewModel?.getProductElement(idProduct: idProduct ?? "")
        homeViewModel?.productElementObservable?.asObservable().subscribe{response in
            print(response.element?.id)
            var imgs = response.element?.images
            self.pageControl.numberOfPages = imgs?.count ?? 0
            for index in 0..<(imgs?.count)! {
                   // 1.
                self.frame.origin.x = self.imageScrollView.frame.size.width * CGFloat(index)
                self.frame.size = self.imageScrollView.frame.size
                   
                   // 2.
                let imgView = UIImageView(frame: self.frame)
                imgView.sd_setImage(with: URL(string: (imgs?[index].src)!), completed: nil)

                   self.imageScrollView.addSubview(imgView)
               }

               // 3.
            self.imageScrollView.contentSize = CGSize(width: (self.imageScrollView.frame.size.width * CGFloat(imgs!.count)), height: self.imageScrollView.frame.size.height)
            self.imageScrollView.delegate = self
        }.disposed(by: disposeBag)
       
    }


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }

}
