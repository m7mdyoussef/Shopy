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
import JGProgressHUD
class CollectionViewController: UIViewController {
    var disposeBag = DisposeBag()
    var collectionViewModel:HomeViewModel?
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var productsView: UIView!
    @IBOutlet weak var adsView: UIView!
    var arrId = [Int]()
    var imagesArr = ["home", "kids", "men", "sale", "women"]
    var arrDiscountCodes = [String]()
    var arrproductId = [String]()
    private var searchBar:UISearchBar!
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var discountCode: UILabel!
    @IBOutlet weak var adsImage: UIImageView!
    
    private var categoryViewModel:CategoryViewModel!
    var showIndicator:ShowIndecator?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        categoryViewModel = CategoryViewModel()
        adsView.roundCorners(corners: .allCorners, radius: 35)
        showIndicator = ShowIndecator(view: view.self)
        adsImage.loadGif(name: imagesArr[0])
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
        
        
        collectionViewModel?.LoadingObservable?.subscribe(onNext: {[weak self] (value) in
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
    
    @IBAction func searchOfProducts(_ sender: Any) {
        let searchCategoryViewController = self.storyboard?.instantiateViewController(identifier: Constants.searchCategoryViewController) as! SearchCategoryViewController
                  searchCategoryViewController.productList = self.collectionViewModel?.ProductElements
                  self.navigationController?.pushViewController(searchCategoryViewController, animated: true)
    }
    
    @IBAction func moveToBag(_ sender: Any) {
    }
    @IBAction func moveToFavourite(_ sender: Any) {
        let vc = FavouriteProductsVC()
        self.navigationController?.pushViewController(vc, animated: true)
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
        let selectedIndexPath = IndexPath(item: 0, section: 0)

        collectionViewModel?.collectionDataObservable?.asObservable().bind(to: menuCollectionView.rx.items(cellIdentifier: Constants.mainCategoryElementCell)){row, items, cell in

            (cell as? MainCategoriesCollectionViewCell)?.mainCategoriesCellLabel.text=items.title
            self.menuCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
            self.arrId.append(items.id)
        }.disposed(by: disposeBag)
        
        menuCollectionView.rx.itemSelected.subscribe{[weak self]value in
            guard let self = self else {return}
            print(self.arrId[value.element?.item ?? 0])
            self.controlViews(flag: true)
            self.collectionViewModel?.getAllProduct(id: String(self.arrId[value.element?.item ?? 0]))
            self.adsImage.loadGif(name: self.imagesArr[value.element?.item ?? 0])
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
           // self.showIndicator?.stopAnimating()
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
