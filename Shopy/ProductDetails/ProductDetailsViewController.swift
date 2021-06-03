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
//import RxRelay

class ProductDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var cardButton: UIButton!
    
    @IBOutlet weak var productDetails: UITextView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var productPrice: UILabel!
    var homeViewModel : HomeModelType?
    var frame = CGRect.zero
    var disposeBag = DisposeBag()
    var idProduct = ""
    var arrOption = BehaviorRelay(value: [""])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewModel = HomeViewModel()
        detailsView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        setupScreens()
        imageScrollView.delegate = self
        registerSizeCell()
       
        sizeCollectionView.rx.setDelegate(self)
        cardButton.roundCorners(corners: .allCorners, radius: 25)
        arrOption.asObservable().bind(to: sizeCollectionView.rx.items(cellIdentifier: "SizesCollectionViewCell")){row, items, cell in
            (cell as? SizesCollectionViewCell)?.productSize.text = String(items)
        }
    }
    
    func setupScreens(){
        homeViewModel?.getProductElement(idProduct: idProduct ?? "")
        homeViewModel?.productElementObservable?.asObservable().subscribe{[weak self]response in
            guard let self = self else {return}
            print(response.element?.id)
            self.productTitle.text = response.element?.title
            self.productPrice.text = response.element?.variants[0].price
            self.productDetails.text = response.element?.bodyHTML
            self.arrOption.accept(((response.element?.options[0].values) ?? []))
            
            var imgs = response.element?.images
            self.pageControl.numberOfPages = imgs?.count ?? 0
            for index in 0..<(imgs?.count)! {
                self.frame.origin.x = self.imageScrollView.frame.size.width * CGFloat(index)
                self.frame.size = self.imageScrollView.frame.size
                let imgView = UIImageView(frame: self.frame)
                imgView.sd_setImage(with: URL(string: (imgs?[index].src)!), completed: nil)
                self.imageScrollView.addSubview(imgView)
               }

            self.imageScrollView.contentSize = CGSize(width: (self.imageScrollView.frame.size.width * CGFloat(imgs!.count)), height: self.imageScrollView.frame.size.height)
            self.imageScrollView.delegate = self
        }.disposed(by: disposeBag)
       
    }


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }

    
    func registerSizeCell(){
        var sizeCell = UINib(nibName: "SizesCollectionViewCell", bundle: nil)
        sizeCollectionView.register(sizeCell, forCellWithReuseIdentifier: "SizesCollectionViewCell")
    }
}

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (self.view.frame.width)/5, height: 25)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
