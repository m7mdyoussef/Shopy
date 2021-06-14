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
import ViewAnimator

class CollectionViewController: UIViewController,ICanLogin {
    var disposeBag = DisposeBag()
    var collectionViewModel:HomeViewModel?
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var favouriteBtn: UIBarButtonItem!
    @IBOutlet weak var bagBtn: UIBarButtonItem!
    var arrId = ["268359598278", "268359631046", "268359663814"]
    var imagesArr = ["men", "women", "kids"]
    var category = "268359598278"
    var arrDiscountCodes = [String]()
    private var searchBar:UISearchBar!
    var isDiscount = false
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var discountCode: UILabel!
    @IBOutlet weak var adsImage: UIImageView!
    let manager = FavouritesPersistenceManager.shared
    let bagManager = BagPersistenceManager.shared
    private var categoryViewModel:CategoryViewModel!
    var showIndicator:ShowIndecator?
    var selectedIndexPath: IndexPath?
    
    var myDiscount:String!
    override func viewDidAppear(_ animated: Bool) {

        let animation = AnimationType.from(direction: .left, offset: 300)
        UIView.animate(views: menuCollectionView.visibleCells, animations: [animation],delay: 0.1,duration: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        startPoint()
    }
    
    func startPoint(){
        categoryViewModel = CategoryViewModel()
        showIndicator = ShowIndecator(view: view.self)
        registerMenuCell()
        registerProductCell()
        productsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        menuCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        controlViews(flag: true)
        collectionViewModel = HomeViewModel()
        collectionViewModel?.getCollectionData()
        productsCollectionView.layer.cornerRadius = 25
        adsView.layer.cornerRadius = 25
        setUpMenuColllection()
        setupProductCollection()
        collectionViewModel?.getPriceRules()
        collectionViewModel?.getDiscountCode(priceRule: "951238656198")
        adsButton.setBackgroundImage(UIImage.gif(name: "offer0"), for: .normal)
        getAllDiscountCodes()
        
        collectionViewModel?.LoadingObservable?.subscribe(onNext: {[weak self] (value) in
            guard let self = self else {return}
            let hud = JGProgressHUD()
            hud.textLabel.text = "Loading".localized
            hud.style = .dark
            hud.show(in: (self.view)!)
            switch value{
            case true:
                hud.dismiss()
            //self.view.isUserInteractionEnabled = false
            case false:
                hud.dismiss()
            //  self.view.isUserInteractionEnabled = true
            
            }
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
//        adsImage.loadGif(name: imagesArr[0])
        
//        MyUserDefaults.add(val: isDiscount, key: .isDisconut)
        
        if let state =  MyUserDefaults.getValue(forKey: .isDisconut){
            
            if state as! Bool == true{
                controlViews(flag: false)
                codeButton.isHidden = true
                adsImage.loadGif(name: "black")
                discountCode.isHidden = true
            }else{
                controlViews(flag: true)
                self.adsImage.loadGif(name: self.imagesArr[0])
            }
        }else{
            controlViews(flag: true)
            self.adsImage.loadGif(name: self.imagesArr[0])
        }
        
        
        if AppCommon.shared.checkConnectivity() == false{
            let NoInternetViewController = self.storyboard?.instantiateViewController(identifier: "NoInternetViewController") as! NoInternetViewController
            NoInternetViewController.modalPresentationStyle = .fullScreen
            self.present(NoInternetViewController, animated: true, completion: nil)
            
        }else{
            
            selectedIndexPath = IndexPath(item: 0, section: 0)
            if collectionViewModel!.isUserLoggedIn() {
                bagBtn.setBadge(text: String(describing: bagManager.retrievebagProducts()?.count ?? 0))
                favouriteBtn.setBadge(text: String(describing: manager.retrieveFavourites()?.count ?? 0))
            }else{
                bagBtn.setBadge(text: String("0"))
                favouriteBtn.setBadge(text: String("0"))
            }
//            controlViews(flag: true)
            self.menuCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
            collectionViewModel?.getAllProduct(id: arrId[0])
            collectionViewModel?.getPriceRules()
            collectionViewModel?.getDiscountCode(priceRule: "951238656198")
            getAllDiscountCodes()
        }
    }
    
    @IBAction func searchOfProducts(_ sender: Any) {
        let searchCategoryViewController = self.storyboard?.instantiateViewController(identifier: Constants.searchCategoryViewController) as! SearchCategoryViewController
        searchCategoryViewController.productList = self.collectionViewModel?.ProductElements
        self.navigationController?.pushViewController(searchCategoryViewController, animated: true)
    }
    @IBAction func selectDiscountCode(_ sender: Any) {
        isDiscount = true
        MyUserDefaults.add(val: isDiscount, key: .isDisconut)
        let popup = AppCommon.shared.showPopupDialog(title: "Congratulation🥳🥳".localized, message: "You got 10% Discount.".localized, image: adsImage.image!)
        self.collectionViewModel?.playWow()
        self.collectionViewModel?.saveDiscountCode(code: myDiscount)
        self.present(popup, animated: true, completion: nil)
    }
    @IBAction func moveToBag(_ sender: Any) {
        if AppCommon.shared.checkConnectivity() == false{
            let NoInternetViewController = self.storyboard?.instantiateViewController(identifier: "NoInternetViewController") as! NoInternetViewController
            NoInternetViewController.modalPresentationStyle = .fullScreen
            self.present(NoInternetViewController, animated: true, completion: nil)
            
        }else{
            if isUserLoggedIn(){
                let bag = BagViewController()
                navigationController?.pushViewController(bag, animated: true)
            }else{
                let vc = storyboard?.instantiateViewController(identifier: Constants.entryPoint) as! EntryPointVC
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        }
        
    }
    @IBAction func moveToFavourite(_ sender: Any) {
        
        if AppCommon.shared.checkConnectivity() == false{
            let NoInternetViewController = self.storyboard?.instantiateViewController(identifier: "NoInternetViewController") as! NoInternetViewController
            NoInternetViewController.modalPresentationStyle = .fullScreen
            self.present(NoInternetViewController, animated: true, completion: nil)
            
        }else{
            if isUserLoggedIn(){
                let vc = FavouriteProductsVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = storyboard?.instantiateViewController(identifier: Constants.entryPoint) as! EntryPointVC
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        }
    }
    @IBAction func showDiscountCode(_ sender: Any) {
        
        let popup = AppCommon.shared.showPopupDialog(title: "OFFER", message: "Please, Click on the code ☝️ to get a Special offer🙈.", image: adsImage.image!)
        self.present(popup, animated: true, completion: nil)
        
        adsImage.loadGif(name: "black")
        adsImage.contentMode = .scaleAspectFill
        adsView.layer.cornerRadius = 25
        adsView.clipsToBounds = true
        adsImage.layer.masksToBounds = true
        controlViews(flag: false)
    }
    
    
    func getAllDiscountCodes(){
        
        collectionViewModel?.discontCodeObservable?.asObservable().subscribe(onNext: {[weak self] (response) in
            guard let self = self else {return}
            for i in 0..<response.count{
                print(response[i].code)
                self.arrDiscountCodes.append(response[i].code)
                self.myDiscount = response[i].code
            }
            self.discountCode.text = response[0].code
        }).disposed(by: disposeBag)
    }
    
    func setUpMenuColllection(){
        collectionViewModel?.mainCategoryObservable?.bind(to: menuCollectionView.rx.items(cellIdentifier: Constants.mainCategoryElementCell)){row, items, cell in
            
            (cell as? MainCategoriesCollectionViewCell)?.mainCategoriesCellLabel.text = items
            self.menuCollectionView.selectItem(at: self.selectedIndexPath, animated: true, scrollPosition: .top)
        }.disposed(by: disposeBag)
        
        menuCollectionView.rx.itemSelected.subscribe{[weak self]value in
            
            guard let self = self else {return}
            
            self.adsImage.contentMode = .scaleAspectFit
//            self.controlViews(flag: true)
            self.collectionViewModel?.getAllProduct(id: self.arrId[value.element?.item ?? 0])
            
            
            if let has =  MyUserDefaults.getValue(forKey: .isDisconut){
                if has as! Bool == true{
                    self.adsImage.loadGif(name: "black")
                }else{
                    self.controlViews(flag: true)
                    self.adsImage.loadGif(name: self.imagesArr[value.element?.item ?? 0])
                }
            }else{
                self.controlViews(flag: true)
                self.adsImage.loadGif(name: self.imagesArr[value.element?.item ?? 0])
                            
            }
            
//            self.adsImage.loadGif(name: self.imagesArr[value.element?.item ?? 0])
            self.discountCode.text = self.arrDiscountCodes[value.element?.item ?? 0]
            self.myDiscount = self.arrDiscountCodes[value.element?.item ?? 0]
        }.disposed(by: disposeBag)
    }
    
    func setupProductCollection(){
        collectionViewModel?.productsDataObservable?.asObservable().bind(to: productsCollectionView.rx.items(cellIdentifier: "ProductCollectionViewCell")){
            row, item, cell in
            (cell as? ProductCollectionViewCell)?.productPrice.text = item.title
            (cell as? ProductCollectionViewCell)?.productImage.sd_setImage(with: URL(string: item.image.src), completed: nil)
        }.disposed(by: disposeBag)
        
        productsCollectionView.rx.modelSelected(ProductElement.self).subscribe{ productElement in
            let element = productElement.element
            if AppCommon.shared.checkConnectivity() == true{
                self.category = self.arrId[0]
                self.controlViews(flag: true)
                self.collectionViewModel?.getProductElement(idProduct: String(element?.id ?? 0) )
                let detailsViewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
                detailsViewController.idProduct = String(element?.id ?? 0)
                self.navigationController?.pushViewController(detailsViewController, animated: true)
            }
        }.disposed(by: disposeBag)
    }
}


