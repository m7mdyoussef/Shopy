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
    var arrDiscountCodes = [String]()
    var arrproductId = [String]()
    private var searchBar:UISearchBar!
    @IBOutlet weak var productSearchBar: UISearchBar!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var discountCode: UILabel!
    @IBOutlet weak var adsImage: UIImageView!
    
    var showIndicator:ShowIndecator?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        adsView.roundCorners(corners: .allCorners, radius: 35)
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 25))
        searchBar.placeholder = "Search..."
        let barButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = barButton
        showIndicator = ShowIndecator(view: view.self)
        registerMenuCell()
        registerProductCell()
        controlViews(flag: true)
        collectionViewModel = HomeViewModel()
        collectionViewModel?.getCollectionData()
        productsCollectionView.rx.setDelegate(self)
        setUpMenuColllection()
        setupProductCollection()
        productsView.roundCorners(corners: [.topLeft, .topRight], radius: 45)
        collectionViewModel?.getPriceRules()
        collectionViewModel?.getDiscountCode(priceRule: "951238656198")
        adsButton.setBackgroundImage(UIImage.gif(name: "offer0"), for: .normal)
        getAllDiscountCodes()
    }
    
    @IBAction func showDiscountCode(_ sender: Any) {
        adsImage.loadGif(name: "black")
        controlViews(flag: false)
    }
    
    func getAllDiscountCodes(){
        collectionViewModel?.discontCodeObservable?.asObservable().subscribe(onNext: {[weak self] (response) in
            guard let self = self else {return}
            for i in 0..<response.count{
                print(response[i].code)
                self.arrDiscountCodes.append(response[i].code)
            }
            self.discountCode.text = response[0].code
        }).disposed(by: disposeBag)
    }
    
    func setUpMenuColllection(){

        showIndicator?.startAnimating()
        collectionViewModel?.collectionDataObservable?.asObservable().bind(to: menuCollectionView.rx.items(cellIdentifier: "MenuCollectionViewCell")){row, items, cell in

            (cell as? MenuCollectionViewCell)?.title.text=items.title
            self.showIndicator?.stopAnimating()
            self.arrId.append(items.id)
        }.disposed(by: disposeBag)
        
        menuCollectionView.rx.itemSelected.subscribe{[weak self]value in
            guard let self = self else {return}
            print(self.arrId[value.element?.item ?? 0])
            self.controlViews(flag: true)
            self.showIndicator?.startAnimating()
            self.collectionViewModel?.getAllProduct(id: String(self.arrId[value.element?.item ?? 0]))
            self.arrproductId.removeAll()
            self.discountCode.text = self.arrDiscountCodes[value.element?.item ?? 0]
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
                self.navigationController?.pushViewController(detailsViewController, animated: true)
            }
        }.disposed(by: disposeBag)
    }
}
