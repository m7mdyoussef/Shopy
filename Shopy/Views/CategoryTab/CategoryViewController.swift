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

class CategoryViewController: UIViewController {

    @IBOutlet private weak var mainCategoryCollectionView: UICollectionView!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    private var db:DisposeBag!
    private var mainCategElement:String = "Men"
    private var subCategElement:String = "T-Shirts"
    private var activityIndicatorView:UIActivityIndicatorView!
    
    private var categoryViewModel:CategoryViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //register custom nib file cells
        let mainCategoryElementCell = UINib(nibName: Constants.mainCategoryElementCell, bundle: nil)
        mainCategoryCollectionView.register(mainCategoryElementCell, forCellWithReuseIdentifier: Constants.mainCategoryElementCell)
        
        let subCategoryElementCell = UINib(nibName: Constants.subCategoryElementCell, bundle: nil)
        subCategoryCollectionView.register(subCategoryElementCell, forCellWithReuseIdentifier: Constants.subCategoryElementCell)
        
        let productCell = UINib(nibName: Constants.productCell, bundle: nil)
        productsCollectionView.register(productCell, forCellWithReuseIdentifier: Constants.productCell)
        
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        categoryViewModel = CategoryViewModel()
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
        
        categoryViewModel.productsObservable.bind(to: productsCollectionView.rx.items(cellIdentifier: Constants.productCell)){ [weak self] row,item,cell in
           let productsCell = cell as! MainProductsCollectionViewCell
            productsCell.productObject = item
        }.disposed(by: db)
        
        
        //if i select item from both sub and main cats
        mainCategoryCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
            self?.subCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
            self?.mainCategElement = value
            self?.subCategElement = "Tshirt"
            self?.categoryViewModel.fetchFilterdProducts(mainCategoryElement: self!.mainCategElement, subCategoryElement: self!.subCategElement)

        }).disposed(by: db)
        
        subCategoryCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
            self?.subCategElement = value
            self?.categoryViewModel.fetchFilterdProducts(mainCategoryElement: self!.mainCategElement, subCategoryElement: self!.subCategElement)

        }).disposed(by: db)

        productsCollectionView.rx.itemSelected.subscribe(onNext: {[weak self] (indexpath) in
        }).disposed(by: db)

    
         categoryViewModel.errorObservable.subscribe(onError: {[weak self] (error) in
             self?.hideLoading()
             }).disposed(by: db)
         
         categoryViewModel.LoadingObservable.subscribe(onNext: {[weak self] (value) in
             switch value{
             case true:
                 self?.showLoading()
             case false:
                 self?.hideLoading()
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
    
}


extension CategoryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView.tag == 1){
            return CGSize(width: (self.view.frame.width)/3, height: 30)
        }else if(collectionView.tag == 2){
            return CGSize(width: 126, height: 30)
        }else{
            return CGSize(width: 128, height: 160)
        }
    }
    
    
}


extension CategoryViewController{
    func showLoading() {
        activityIndicatorView!.center = self.view.center
        self.view.addSubview(activityIndicatorView!)
        activityIndicatorView!.startAnimating()
    }
    
    func hideLoading() {
        activityIndicatorView!.stopAnimating()
    }
    
    func showErrorMessage(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel)
        { action -> Void in
           
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
