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
import ViewAnimator

class SearchCategoryViewController: UIViewController {
    
    var productList:[ProductElement]!
    var categorySearchViewModel:CategorySearchViewModel!
    var collectionViewModel:HomeViewModel?
    private var searchBar:UISearchBar!
    private var db:DisposeBag!
    private var sortingMenu:DropDown!
    private var filteringMenu:DropDown!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var filter: UIButton!
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet private weak var categorySearchResultCollectionView: UICollectionView!
    
    private var arrproductId = [String]()

    
    override func viewDidAppear(_ animated: Bool) {
           
             let animation1 = AnimationType.random()
             UIView.animate(views: categorySearchResultCollectionView.visibleCells,animations: [animation1],delay: 0.5,duration: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
  filterView.roundCorners(corners: .allCorners, radius: 8)
  sortView.roundCorners(corners: .allCorners, radius: 8)
  resetView.roundCorners(corners: .allCorners, radius: 8)
  mainView.roundCorners(corners: [.topLeft, .topRight], radius: 35)

        // register product nib cell
        let productCell = UINib(nibName: Constants.productCell, bundle: nil)
        categorySearchResultCollectionView.register(productCell, forCellWithReuseIdentifier: Constants.productCell)

        
        //initialize dropList
            sortingMenu = DropDown()
            filteringMenu = DropDown()
            sortingMenu.anchorView = sortView
            filteringMenu.anchorView = filterView
        sortingMenu.dataSource = ["Price: Highiest to lowest".localized,"Price: Lowest to Highiest".localized]
        filteringMenu.dataSource = ["T-Shirts".localized,"Shoes".localized,"Accessories".localized]
            sortingMenu.direction = .bottom
            filteringMenu.direction = .bottom
            sortingMenu.bottomOffset = CGPoint(x: 0, y:sortView.plainView.bounds.height)
            filteringMenu.bottomOffset = CGPoint(x: 0, y:filterView.plainView.bounds.height)
        
        //create search bar in run time
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 42))
        searchBar.placeholder = "Search...".localized
        let barButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.rightBarButtonItem = barButton
        self.searchBar.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.searchBar.roundCorners(corners: .allCorners, radius: 6)

        categorySearchViewModel = CategorySearchViewModel()
        collectionViewModel = HomeViewModel()

        db = DisposeBag()
        categorySearchViewModel.fetchData()

        categorySearchResultCollectionView.rx.setDelegate(self).disposed(by: db)
        
        searchBar.rx.text
        .orEmpty.distinctUntilChanged().bind(to: categorySearchViewModel.searchWord).disposed(by: db)
        
        categorySearchViewModel.productsObservable.bind(to: categorySearchResultCollectionView.rx.items(cellIdentifier: Constants.productCell)){row,item,cell in
            
           let productCell = cell as! MainProductsCollectionViewCell
            productCell.DetailedProductObject = item
            self.arrproductId.append(String(item.id))
        }.disposed(by: db)
        
       
        
        //dropList actions
        sortingMenu.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.categorySearchViewModel.sortData(index: index)
        }
        
        filteringMenu.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.categorySearchViewModel.filterData(word: item)

        }
        
        categorySearchResultCollectionView.rx.modelSelected(DetailedProducts.self).subscribe{[weak self]value in
            guard let self = self else {return}
            print(value.element?.id)
            let detailsViewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
                detailsViewController.idProduct = String(value.element?.id ?? 0)
                 
                self.navigationController?.pushViewController(detailsViewController, animated: true)
        }.disposed(by: db)
        
//        categorySearchResultCollectionView.rx.itemSelected.subscribe{value in
//
//                    print(value.element?.item)
//        //            if AppCommon.shared.checkConnectivity() == true{
//                       // self.controlViews(flag: true)
//                        //self.collectionViewModel?.getProductElement(idProduct: String(self.arrproductId[value.element?.item ?? 0]))
//
//                   // }
//                }.disposed(by: db)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    @IBAction func clickToFilter(_ sender: Any) {
        filteringMenu.show()
        arrproductId.removeAll()
    }
    @IBAction func clickToSort(_ sender: Any) {
        sortingMenu.show()
        arrproductId.removeAll()
    }
    

    @IBAction func resetSortAndFilter(_ sender: Any) {
        categorySearchViewModel.clearData()
        searchBar.text = ""
        arrproductId.removeAll()
    }
}


extension SearchCategoryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 128, height: 160)
    }
    
}
