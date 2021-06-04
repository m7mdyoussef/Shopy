//
//  CollectionViewController.swift
//  Shopy
//
//  Created by SOHA on 5/28/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage
import ImageIO
class CollectionViewController: UIViewController {
    var disposeBag = DisposeBag()
    var collectionViewModel:HomeViewModel?
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var productsView: UIView!
    @IBOutlet weak var adsView: UIView!
    var arrId = [Int]()
    var arrproductId = [String]()
    @IBOutlet weak var productSearchBar: UISearchBar!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var discountCode: UILabel!
    @IBOutlet weak var adsImage: UIImageView!
    
    var showIndicator:ShowIndecator?
    override func viewDidLoad() {
        super.viewDidLoad()
        showIndicator = ShowIndecator(view: view.self)
        // self.navigationController?.isNavigationBarHidden = true
        // adsView.roundCorners(corners: .allCorners, radius: 35)
        registerMenuCell()
        registerProductCell()
        controlViews(flag: true)
        collectionViewModel = HomeViewModel()
        collectionViewModel?.getCollectionData()
        productsCollectionView.rx.setDelegate(self)
        setUpMenuColllection()
        setupProductCollection()
        productsView.roundCorners(corners: [.topLeft, .topRight], radius: 35)
        collectionViewModel?.getPriceRules()
        collectionViewModel?.getDiscountCode(priceRule: "950837444806")
        adsButton.setBackgroundImage(UIImage.gif(name: "offer0"), for: .normal)
       
    }
    
    
    @IBAction func showDiscountCode(_ sender: Any) {
        adsImage.loadGif(name: "black")
        controlViews(flag: false)
        
    }
    
    func controlViews(flag:Bool){
        if (flag == true){
            adsButton.isHidden = false
            discountCode.isHidden = true
            adsImage.isHidden = true
        }else{
            adsButton.isHidden = true
            discountCode.isHidden = false
            adsImage.isHidden = false
        }
    }
    
    func setUpMenuColllection(){
        showIndicator?.startAnimating()
        collectionViewModel?.collectionDataObservable?.asObservable().bind(to: menuCollectionView.rx.items(cellIdentifier: "MenuCollectionViewCell")){row, items, cell in
            (cell as? MenuCollectionViewCell)?.title.text=items.title
            self.showIndicator?.stopAnimating()
            self.arrId.append(items.id)
        }.disposed(by: disposeBag)
        
        
        menuCollectionView.rx.itemSelected.subscribe{value in
            print(self.arrId[value.element?.item ?? 0])
            self.controlViews(flag: true)
            self.showIndicator?.startAnimating()
            self.collectionViewModel?.getAllProduct(id: String(self.arrId[value.element?.item ?? 0]))
            self.arrproductId.removeAll()
            
        }.disposed(by: disposeBag)
    }
    
    func setupProductCollection(){
       
        collectionViewModel?.productsDataObservable?.asObservable().bind(to: productsCollectionView.rx.items(cellIdentifier: "ProductCollectionViewCell")){
            row, item, cell in
            (cell as? ProductCollectionViewCell)?.productPrice.text = item.title
            (cell as? ProductCollectionViewCell)?.productImage.sd_setImage(with: URL(string: item.image.src), completed: nil)
            self.arrproductId.append(String(item.id))
            self.showIndicator?.stopAnimating()
            
        }.disposed(by: disposeBag)
        
        
        productsCollectionView.rx.itemSelected.subscribe{value in
            print(value.element?.item)
            if AppCommon.shared.checkConnectivity() == true{
                self.controlViews(flag: true)
                self.collectionViewModel?.getProductElement(idProduct: String(self.arrproductId[value.element?.item ?? 0]))
                var detailsViewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
                detailsViewController.idProduct = String(self.arrproductId[value.element?.item ?? 0])
                self.collectionViewModel?.getDiscountCode(priceRule: "950837444806")
                
                self.navigationController?.pushViewController(detailsViewController, animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
    func registerProductCell(){
        var productCell = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productsCollectionView.register(productCell, forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
    
    func registerMenuCell(){
        var menuCell = UINib(nibName: "MenuCollectionViewCell", bundle: nil)
        menuCollectionView.register(menuCell, forCellWithReuseIdentifier: "MenuCollectionViewCell")
    }
}
