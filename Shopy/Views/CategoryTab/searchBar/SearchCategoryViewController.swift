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
import DropDown

class SearchCategoryViewController: UIViewController {
    
    var productList:[ProductElement]!
    var categorySearchViewModel:CategorySearchViewModel!
    private var searchBar:UISearchBar!
    private var db:DisposeBag!
    private var sortingMenu:DropDown!
    private var filteringMenu:DropDown!
    
    @IBOutlet weak var containingToolBar: UIToolbar!
    @IBOutlet private weak var sortingBtn: UIBarButtonItem!
    @IBOutlet private weak var filteringBtn: UIBarButtonItem!
    @IBOutlet private weak var categorySearchResultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
  
        
        // register product nib cell
        let productCell = UINib(nibName: Constants.productCell, bundle: nil)
        categorySearchResultCollectionView.register(productCell, forCellWithReuseIdentifier: Constants.productCell)

        
        //initialize dropList
            sortingMenu = DropDown()
            filteringMenu = DropDown()
            sortingMenu.anchorView = sortingBtn
            filteringMenu.anchorView = filteringBtn
            sortingMenu.dataSource = ["Price: Highiest to lowest","Price: Lowest to Highiest"]
            filteringMenu.dataSource = ["T-Shirts","Shoes","Accessories"]
            sortingMenu.direction = .bottom
            filteringMenu.direction = .bottom
            sortingMenu.bottomOffset = CGPoint(x: 0, y:containingToolBar.frame.height)
            filteringMenu.bottomOffset = CGPoint(x: 0, y:containingToolBar.frame.height)
        
        //create search bar in run time
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 25))
        searchBar.placeholder = "Search..."
        let barButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = barButton
        
        categorySearchViewModel = CategorySearchViewModel()
        db = DisposeBag()
        
        categorySearchResultCollectionView.rx.setDelegate(self).disposed(by: db)
        
        searchBar.rx.text
        .orEmpty.distinctUntilChanged().bind(to: categorySearchViewModel.searchWord).disposed(by: db)
        
        categorySearchViewModel.productsObservable.bind(to: categorySearchResultCollectionView.rx.items(cellIdentifier: Constants.productCell)){row,item,cell in
           let productCell = cell as! MainProductsCollectionViewCell
            productCell.DetailedProductObject = item
        }.disposed(by: db)
        
        categorySearchViewModel.fetchData()

        
        //dropList actions
        sortingMenu.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.categorySearchViewModel.sortData(index: index)
        }
        
        filteringMenu.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.categorySearchViewModel.filterData(word: item)

        }
        
    }
    

    @IBAction func clickSortBtn(_ sender: UIBarButtonItem) {
        sortingMenu.show()
    }
    
    @IBAction func clickFilterBtn(_ sender: UIBarButtonItem) {
        filteringMenu.show()
    }
}


extension SearchCategoryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 128, height: 160)
    }
    
}
