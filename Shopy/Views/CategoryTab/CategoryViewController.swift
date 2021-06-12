//
//  CategoryViewController.swift
//  Shopy
//
//  Created by mohamed youssef on 5/25/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

class CategoryViewController: UIViewController,ICanLogin {

    @IBOutlet weak var subCatView: UIView!
    @IBOutlet private weak var mainCategoryCollectionView: UICollectionView!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    private var db:DisposeBag!
    private var mainCategElement:String = "Men"
    private var subCategElement:String = "T-Shirts"
    private var activityIndicatorView:UIActivityIndicatorView!
    
    private var categoryViewModel = CategoryViewModel()
    private var collectionViewModel = HomeViewModel()
    private var arrproductId = [String]()

    
    override func viewWillAppear(_ animated: Bool) {
       // super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        if AppCommon.shared.checkConnectivity() == false{
            let NoInternetViewController = self.storyboard?.instantiateViewController(identifier: "NoInternetViewController") as! NoInternetViewController
            NoInternetViewController.fromWhere = "category"
            NoInternetViewController.vcIdentifier = "CategoryViewController"
            NoInternetViewController.modalPresentationStyle = .fullScreen
            self.present(NoInternetViewController, animated: true, completion: nil)
           
        }else{
            arrproductId.removeAll()
            subCategElement = "T-Shirts"
            mainCategElement = "Men"
            categoryViewModel.fetchData()
            categoryViewModel.fetchFilterdProducts(mainCategoryElement: mainCategElement, subCategoryElement: subCategElement)
        }
        



    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black

        
        subCatView.roundCorners(corners: .allCorners, radius: 20)
       //  productView.roundCorners(corners: .allCorners, radius: 20)
        //register custom nib file cells
        productsCollectionView.layer.cornerRadius = 20
        productsCollectionView.clipsToBounds = true
        let mainCategoryElementCell = UINib(nibName: Constants.mainCategoryElementCell, bundle: nil)
        mainCategoryCollectionView.register(mainCategoryElementCell, forCellWithReuseIdentifier: Constants.mainCategoryElementCell)
        
        let subCategoryElementCell = UINib(nibName: Constants.subCategoryElementCell, bundle: nil)
        subCategoryCollectionView.register(subCategoryElementCell, forCellWithReuseIdentifier: Constants.subCategoryElementCell)
        
        let productCell = UINib(nibName: Constants.productCell, bundle: nil)
        productsCollectionView.register(productCell, forCellWithReuseIdentifier: Constants.productCell)
        
   //     activityIndicatorView = UIActivityIndicatorView(style: .large)
//        categoryViewModel = CategoryViewModel()
//        collectionViewModel = HomeViewModel()
        db = DisposeBag()
        
        // collectionViews Deleget
        mainCategoryCollectionView.rx.setDelegate(self).disposed(by: db)
        subCategoryCollectionView.rx.setDelegate(self).disposed(by: db)
        productsCollectionView.rx.setDelegate(self).disposed(by: db)


        //first item selected at first
        let selectedIndexPath = IndexPath(item: 0, section: 0)

        //binding viewModel observables
        categoryViewModel.mainCategoryElementsObservable.bind(to: mainCategoryCollectionView.rx.items(cellIdentifier: Constants.mainCategoryElementCell)){ [weak self] row,item,cell in
           let mainCategoryCell = cell as! MainCategoriesCollectionViewCell
            mainCategoryCell.mainCategoriesCellLabel.text = item
            self?.mainCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
        }.disposed(by: db)
        
        categoryViewModel.subCategoryElementsObservable.bind(to: subCategoryCollectionView.rx.items(cellIdentifier: Constants.subCategoryElementCell)){ [weak self] row,item,cell in
           let subCategoryCell = cell as! SubCategoriesCollectionViewCell
           subCategoryCell.subCategorieslabel.text = item
            self?.subCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
        }.disposed(by: db)
        
        categoryViewModel.productsObservable.bind(to: productsCollectionView.rx.items(cellIdentifier: Constants.productCell)){ row,item,cell in
           let productsCell = cell as! MainProductsCollectionViewCell
            productsCell.productObject = item
            self.arrproductId.append(String(item.id))
        }.disposed(by: db)
        
        
        //if i select item from both sub and main cats
        mainCategoryCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
            self?.subCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
            self?.mainCategElement = value
            self?.subCategElement = "T-Shirts"
            self?.categoryViewModel.fetchFilterdProducts(mainCategoryElement: self!.mainCategElement, subCategoryElement: self!.subCategElement)
            self?.arrproductId.removeAll()
        }).disposed(by: db)
        
        subCategoryCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
            self?.subCategElement = value
            self?.categoryViewModel.fetchFilterdProducts(mainCategoryElement: self!.mainCategElement, subCategoryElement: self!.subCategElement)
            self?.arrproductId.removeAll()
        }).disposed(by: db)

      
        
        productsCollectionView.rx.itemSelected.subscribe{value in
           // print(value.element?.item)
           if AppCommon.shared.checkConnectivity() == true{
               // self.controlViews(flag: true)
            self.collectionViewModel.getProductElement(idProduct: String(self.arrproductId[value.element?.item ?? 0]))
            let detailsViewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
                detailsViewController.idProduct = String(self.arrproductId[value.element?.item ?? 0])
                self.navigationController?.pushViewController(detailsViewController, animated: true)
            }
        }.disposed(by: db)
        
        
//        productsCollectionView.rx.itemSelected.subscribe(onNext: {[weak self] (indexpath) in
//        }).disposed(by: db)

    
         categoryViewModel.errorObservable.subscribe(onError: {[weak self] (error) in
             self?.hideLoading()
             }).disposed(by: db)
         
         categoryViewModel.LoadingObservable.subscribe(onNext: {[weak self] (value) in
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
         }).disposed(by: db)

         categoryViewModel.fetchData()
         categoryViewModel.fetchFilterdProducts(mainCategoryElement: mainCategElement, subCategoryElement: subCategElement)
        
    }

    @IBAction func searchCategoryProducts(_ sender: Any) {
        let searchCategoryViewController = storyboard?.instantiateViewController(identifier: Constants.searchCategoryViewController) as! SearchCategoryViewController
        searchCategoryViewController.productList = categoryViewModel.ProductElements
        navigationController?.pushViewController(searchCategoryViewController, animated: true)
    }
    
    @IBAction func moveToBag(_ sender: Any) {
//        if isUserLoggedIn(){
//            let bag = BagViewController()
//            navigationController?.pushViewController(bag, animated: true)
//        }else{
//            presentGFAlertOnMainThread(title: "Warning!!", message: "Please login", buttonTitle: "OK")
//        }
        
        if AppCommon.shared.checkConnectivity() == false{
            let NoInternetViewController = self.storyboard?.instantiateViewController(identifier: "NoInternetViewController") as! NoInternetViewController
            NoInternetViewController.modalPresentationStyle = .fullScreen
            self.present(NoInternetViewController, animated: true, completion: nil)
            
        }else{
            if isUserLoggedIn(){
                let bag = BagViewController()
                navigationController?.pushViewController(bag, animated: true)
            }else{
                presentGFAlertOnMainThread(title: "Warning!!", message: "Please login", buttonTitle: "OK")
            }
        }

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

       // productsCollectionView.reloadData()
        view.setNeedsLayout()
    }
    
    @IBAction func uiShowFavourite(_ sender: Any) {
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
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}


extension CategoryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView.tag == 1){
            return CGSize(width: (self.view.frame.width)/3, height: 30)
        }else if(collectionView.tag == 2){
            return CGSize(width: 126, height: 30)
        }else{
            return CGSize(width: 130, height: 175)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    
    
}


extension CategoryViewController{
    func showLoading() {
        activityIndicatorView!.center = self.view.center
        self.view.addSubview(activityIndicatorView!)
        activityIndicatorView?.startAnimating()
    }
    
    func hideLoading() {
        activityIndicatorView?.stopAnimating()
    }
    
    func showErrorMessage(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel)
        { action -> Void in
           
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
