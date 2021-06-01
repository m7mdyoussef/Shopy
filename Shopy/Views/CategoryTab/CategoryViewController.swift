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
    
    
    private var categoryViewModel:CategoryViewModel!
    private var disposeBag:DisposeBag!
    private var mainCat:String = "Men"
    private var subCat:String = "T-Shirts"
    private var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //register cell nib file
        let mainCatNibCell = UINib(nibName: Constants.mainCatNibCelln, bundle: nil)
        mainCategoryCollectionView.register(mainCatNibCell, forCellWithReuseIdentifier: Constants.mainCatNibCelln)
        
        let subCatNibCell = UINib(nibName: Constants.subCatNibCell, bundle: nil)
        subCategoryCollectionView.register(subCatNibCell, forCellWithReuseIdentifier: Constants.subCatNibCell)
        
        let productNibCell = UINib(nibName: Constants.productNibCell, bundle: nil)
        productsCollectionView.register(productNibCell, forCellWithReuseIdentifier: Constants.productNibCell)
        
        //initialization
        categoryViewModel = CategoryViewModel()
        disposeBag = DisposeBag()
        activityView = UIActivityIndicatorView(style: .large)
        
        //setting delegates
        mainCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        subCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        productsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)


        //select first item at initialization
        let selectedIndexPath = IndexPath(item: 0, section: 0)

        //bindingData from viewModel
        categoryViewModel.mainCatDataObservable.bind(to: mainCategoryCollectionView.rx.items(cellIdentifier: Constants.mainCatNibCelln)){ [weak self] row,item,cell in
           let castedCell = cell as! MainCategoriesCollectionViewCell
            castedCell.mainCategoriesCellLabel.text = item
            self?.mainCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
        }.disposed(by: disposeBag)
        
        categoryViewModel.subCatDataObservable.bind(to: subCategoryCollectionView.rx.items(cellIdentifier: Constants.subCatNibCell)){ [weak self] row,item,cell in
           let castedCell = cell as! SubCategoriesCollectionViewCell
            castedCell.subCategorieslabel.text = item
            self?.subCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
        }.disposed(by: disposeBag)
        
        categoryViewModel.productDataObservable.bind(to: productsCollectionView.rx.items(cellIdentifier: Constants.productNibCell)){ [weak self] row,item,cell in
           let castedCell = cell as! MainProductsCollectionViewCell
            castedCell.productObject = item
        }.disposed(by: disposeBag)
        
        
        //when item selected
        mainCategoryCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
            self?.subCategoryCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
            self?.mainCat = value
            self?.subCat = "Tshirt"
            self?.categoryViewModel.fetchCatProducts(mainCat: self!.mainCat, subCat: self!.subCat)

        }).disposed(by: disposeBag)
        
        subCategoryCollectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] (value) in
            self?.subCat = value
            print(self?.subCat ?? "")
            self?.categoryViewModel.fetchCatProducts(mainCat: self!.mainCat, subCat: self!.subCat)

        }).disposed(by: disposeBag)

        productsCollectionView.rx.itemSelected.subscribe(onNext: {[weak self] (indexpath) in
        }).disposed(by: disposeBag)

        //listen while getting data
         categoryViewModel.errorObservable.subscribe(onError: {[weak self] (error) in
             self?.hideLoading()
             }).disposed(by: disposeBag)
         
         categoryViewModel.LoadingObservable.subscribe(onNext: {[weak self] (value) in
             switch value{
             case true:
                 self?.showLoading()
             case false:
                 self?.hideLoading()
             }
         }).disposed(by: disposeBag)

         categoryViewModel.fetchData()
         categoryViewModel.fetchCatProducts(mainCat: mainCat, subCat: subCat)
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


extension CategoryViewController{
    func showLoading() {
        activityView!.center = self.view.center
        self.view.addSubview(activityView!)
        activityView!.startAnimating()
    }
    
    func hideLoading() {
        activityView!.stopAnimating()
    }
    
    func showErrorMessage(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: "An Error Occured", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel)
        { action -> Void in
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
