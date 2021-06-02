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
class CollectionViewController: UIViewController {
    var disposeBag = DisposeBag()
    var collectionViewModel:HomeViewModel?
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var productsView: UIView!
    
    @IBOutlet weak var adsView: UIView!
    var arrId = [Int]()
    var arrproductId = [Int]()
    @IBOutlet weak var menuCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.navigationController?.isNavigationBarHidden = true
      //  adsView.roundCorners(corners: .allCorners, radius: 35)
        registerMenuCell()
        registerProductCell()
        collectionViewModel = HomeViewModel()
        collectionViewModel?.getCollectionData()
        productsCollectionView.rx.setDelegate(self)
        setUpMenuColllection()
        setupProductCollection()
        productsView.roundCorners(corners: [.topLeft, .topRight], radius: 35)
       
    }
    
    func setUpMenuColllection(){
        
        collectionViewModel?.collectionDataObservable?.asObservable().bind(to: menuCollectionView.rx.items(cellIdentifier: "MenuCollectionViewCell")){row, items, cell in
            (cell as? MenuCollectionViewCell)?.title.text=items.title
            self.arrId.append(items.id)
        }.disposed(by: disposeBag)
        
        menuCollectionView.rx.itemSelected.subscribe{value in
            
            print(self.arrId[value.element?.item ?? 0])
            self.collectionViewModel?.getAllProduct(id: String(self.arrId[value.element?.item ?? 0]))
           
            
        }.disposed(by: disposeBag)
    }
    
    func setupProductCollection(){
        collectionViewModel?.productsDataObservable?.asObservable().bind(to: productsCollectionView.rx.items(cellIdentifier: "ProductCollectionViewCell")){
            row, item, cell in
            (cell as? ProductCollectionViewCell)?.productPrice.text = item.title
            (cell as? ProductCollectionViewCell)?.productImage.sd_setImage(with: URL(string: item.image.src), completed: nil)
            self.arrproductId.append(item.id)
        }.disposed(by: disposeBag)
        
        productsCollectionView.rx.itemSelected.subscribe{value in
            print(value.element?.item)
            self.collectionViewModel?.getProductElement(idProduct: String(self.arrproductId[value.element?.item ?? 0]))
            var detailsViewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
            detailsViewController.idProduct = String(self.arrproductId[value.element?.item ?? 0])
            self.navigationController?.pushViewController(detailsViewController, animated: true)
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



