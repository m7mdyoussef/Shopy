//
//  SearchCategoryViewController.swift
//  Shopy
//
//  Created by mohamed youssef on 6/2/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchCategoryViewController: UIViewController {
    
    var productList:[ProductElement]!
    var categorySearchViewModel:CategorySearchViewModel!
    private var searchBar:UISearchBar!
     private var db:DisposeBag!
    
    @IBOutlet private weak var categorySearchResultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        // register product nib cell
        let productCell = UINib(nibName: Constants.productCell, bundle: nil)
        categorySearchResultCollectionView.register(productCell, forCellWithReuseIdentifier: Constants.productCell)

        
        //create search bar in run time
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 25))
        searchBar.placeholder = "Search..."
        let barButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = barButton
        
        categorySearchViewModel = CategorySearchViewModel(products: productList)
        db = DisposeBag()
        
        categorySearchResultCollectionView.rx.setDelegate(self).disposed(by: db)
        
        searchBar.rx.text
        .orEmpty.distinctUntilChanged().bind(to: categorySearchViewModel.searchWord).disposed(by: db)
        
        categorySearchViewModel.productsObservable.bind(to: categorySearchResultCollectionView.rx.items(cellIdentifier: Constants.productCell)){row,item,cell in
           let productCell = cell as! MainProductsCollectionViewCell
            productCell.productObject = item
        }.disposed(by: db)
        
        categorySearchViewModel.fetchData()

    }
    


}


extension SearchCategoryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 128, height: 160)
    }
    
}
