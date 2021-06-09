//
//  MeVC.swift
//  Shopy
//
//  Created by Amin on 06/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import HMSegmentedControl
import JGProgressHUD
import RxSwift
import RxCocoa

class MeVC: UIViewController {
    
    @IBOutlet weak var uiWishlistCollection: UICollectionView!
    @IBOutlet weak var uiOrdersCollection: UICollectionView!
    @IBOutlet weak var uiEmptyWishListImage: UIImageView!
    @IBOutlet weak var uiEmptyOrdersListImage: UIImageView!
    @IBOutlet weak var uiStack: UIStackView!
    @IBOutlet weak var uiScrollViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var uiScrollView: UIScrollView!
    
    var viewModel:MeTapViewModel!
    
    var segmentedControl: HMSegmentedControl!
    var segmentsArray: [(state:FinancialStatus,value:String)] = []
    
    var bag = DisposeBag()
    
    var hud : JGProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MeTapViewModel()
        setupViews()
    }
    
    func setupViews()  {
        registerCollectionViewCells()
        addingOrdersStatusSegments()
        setupWishlistCollectionView()
        setupOrdersCollectionView()
        uiWishlistCollection.rx.setDelegate(self).disposed(by: bag)
        uiOrdersCollection.rx.setDelegate(self).disposed(by: bag)
        
        viewModel.loadingObservable.asObservable().subscribe{ [unowned self] value in
            guard let value = value.element else {return}
            if value {
                hud = loadingHud(text: "Loading", style: .dark)
            }else{
                dismissLoadingHud(hud: hud)
            }
        }.disposed(by: bag)
    }
    
    func registerCollectionViewCells() {
        var cell = UINib(nibName: "FavouriteproductCVC", bundle: nil)
        uiWishlistCollection.register(cell, forCellWithReuseIdentifier: "FavouriteproductCVC")
        cell = UINib(nibName: "OrderCell", bundle: nil)
        uiOrdersCollection.register(cell, forCellWithReuseIdentifier: "OrderCell")
    }
    
    func addingOrdersStatusSegments() {
        
        segmentsArray.append((state: .pending, value: FinancialStatus.pending.rawValue))
        segmentsArray.append((state: .authorized, value: FinancialStatus.authorized.rawValue))
        segmentsArray.append((state: .partiallyPaid, value: FinancialStatus.partiallyPaid.rawValue))
        segmentsArray.append((state: .paid, value: FinancialStatus.paid.rawValue))
        segmentsArray.append((state: .partiallyRefunded, value: FinancialStatus.partiallyPaid.rawValue))
        segmentsArray.append((state: .voided, value: FinancialStatus.voided.rawValue))
    
        let segmentsNames = segmentsArray.map{$0.value}
        segmentedControl = HMSegmentedControl(sectionTitles: segmentsNames)
        segmentedControl.borderWidth = CGFloat(1)
        segmentedControl.selectionIndicatorColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        segmentedControl.selectionIndicatorLocation = .bottom
        segmentedControl.selectionIndicatorHeight = 2
        segmentedControl.addTarget(self, action: #selector(listenToSegment(sender:)), for: .valueChanged)
        uiStack.addArrangedSubview(segmentedControl)
    }
    
    @objc func listenToSegment(sender:HMSegmentedControl){
        fetchOrders()
    }
    
    func fetchOrders() {
        let financialState = segmentsArray[Int(segmentedControl.selectedSegmentIndex)].state
        viewModel.fetchOrders(status: financialState)
    }
    
    func setupWishlistCollectionView()  {
        viewModel.favProductsObservable?.asObservable().bind(to: uiWishlistCollection.rx.items(cellIdentifier: "FavouriteproductCVC")){
            row,item,cell in
            (cell as? FavouriteproductCVC)?.favProduct = item
            (cell as? FavouriteproductCVC)?.deleteFromFavourites = { [unowned self] in
                deletFromFavourites(productID: Int(item.id ))
            }
            
        }.disposed(by: bag)
        
        
        uiWishlistCollection.rx.itemSelected.subscribe{ value in
            print("tapped")
        }.disposed(by: bag)
        
    }
    
    func setupOrdersCollectionView() {
        viewModel.ordersObservable?.asObservable().bind(to: uiOrdersCollection.rx.items(cellIdentifier: "OrderCell")){
            row,item,cell in
            (cell as? OrderCell)?.orderData = item
        }.disposed(by: bag)
        
//        uiOrdersCollection.rx.itemSelected.subscribe{value in
////            print(value.element.ite)
//        }.disposed(by: bag)
//
        uiOrdersCollection.rx.modelSelected(Order.self).subscribe{
            value in
            
        }.disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        if viewModel.isUserLoggedIn() {
            showGreatingMessage()
            
            viewModel.favProductsObservable?.drive(onNext: { [unowned self] (favProducts) in
                resetWishListViews(count:favProducts.count)
                uiWishlistCollection.reloadData()
            }).disposed(by: bag)
            
            viewModel.ordersObservable?.drive(onNext: { [unowned self] (orders) in
                uiOrdersCollection.reloadData()
                resetOrdersListViews(count: orders.count)
            }).disposed(by: bag)
            
            viewModel.fetchFavProducts()
            fetchOrders()
        }else{
            let vc = storyboard?.instantiateViewController(identifier: Constants.entryPoint) as! EntryPointVC
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showGreatingMessage() {
        navigationItem.title = "Hello,\(viewModel.getUserName())"
    }
    
    func deletFromFavourites(productID : Int) {
        let localData = FavouritesPersistenceManager.shared
        localData.removeProduct(productID: productID)
        uiWishlistCollection.reloadData()
    }
    
    
    func resetWishListViews(count:Int) {
        if count > 0 {
            uiEmptyWishListImage.isHidden = true
            uiWishlistCollection.isHidden = false
        }else{
            uiEmptyWishListImage.isHidden = false
            uiWishlistCollection.isHidden = true
        }
    }
    
    func resetOrdersListViews(count:Int) {
        if count > 0 {
            uiEmptyOrdersListImage.isHidden = true
            uiOrdersCollection.isHidden = false
//            uiScrollViewHeigh.constant = uiOrdersCollection.contentSize.height + uiOrdersCollection.contentSize.height
            uiScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
            uiOrdersCollection.contentSize = CGSize(width: self.view.frame.size.width, height: uiOrdersCollection.contentSize.height)

        }else{
            uiEmptyOrdersListImage.isHidden = false
            uiOrdersCollection.isHidden = true
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        uiWishlistCollection.reloadData()
    }
}

extension MeVC : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        1
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = CGFloat(10)
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return CGSize(width: CGFloat(view.layer.frame.width / 2), height: CGFloat(view.layer.frame.height * 1/4  ))
        return CGSize(width: CGFloat(200), height: CGFloat(view.layer.frame.height * 1/3.5  ))
    }
    
}


