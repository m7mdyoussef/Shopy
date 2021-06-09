//
//  MeVC.swift
//  Shopy
//
//  Created by Amin on 06/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import HMSegmentedControl
import RxSwift
import RxCocoa

class MeVC: UIViewController {
    
    @IBOutlet weak var uiWishlistCollection: UICollectionView!
    @IBOutlet weak var uiOrdersCollection: UICollectionView!
    @IBOutlet weak var uiEmptyWishListImage: UIImageView!
    @IBOutlet weak var uiEmptyOrdersListImage: UIImageView!
    @IBOutlet weak var uiStack: UIStackView!
    
    var viewModel:MeTapViewModel!
    
    var segmentedControl: HMSegmentedControl!
    var segmentsArray: [(state:FinancialStatus,value:String)] = []
    
    var bag = DisposeBag()
    var dispatchGroup = DispatchGroup()
    
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
        viewModel.favProducts?.asObservable().bind(to: uiWishlistCollection.rx.items(cellIdentifier: "FavouriteproductCVC")){
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
        viewModel.orders?.asObservable().bind(to: uiOrdersCollection.rx.items(cellIdentifier: "OrderCell")){
            row,item,cell in
            (cell as? OrderCell)?.orderData = item
        }.disposed(by: bag)
        
//        uiOrdersCollection.rx.itemSelected.subscribe{value in
////            print(value.element.ite)
//        }.disposed(by: bag)
//
        uiOrdersCollection.rx.modelSelected(Order.self).subscribe{
            value in
            print(value.element?.email ?? "test")
        }.disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        if viewModel.isUserLoggedIn() {
            showGreatingMessage()
            
            viewModel.favProducts?.drive(onNext: { [unowned self] (favProducts) in
                resetWishListViews(count:favProducts.count)
                uiWishlistCollection.reloadData()
            }).disposed(by: bag)
            
            viewModel.orders?.drive(onNext: { [unowned self] (orders) in
                resetOrdersListViews(count: orders.count)
                uiOrdersCollection.reloadData()
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
        }else{
            uiEmptyOrdersListImage.isHidden = false
            uiOrdersCollection.isHidden = true
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        uiWishlistCollection.reloadData()
    }
    @IBAction func settingsAction(_ sender: Any) {
       let settingsVC = SettingsVC()
        navigationController?.pushViewController(settingsVC , animated: true)
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
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return favProductCount
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //
    //        let cell = uiWishlistCollection.dequeueReusableCell(withReuseIdentifier: "FavouriteproductCVC", for: indexPath) as! FavouriteproductCVC
    //
    //        cell.favProduct = favProducts[indexPath.item]
    //        cell.deleteFromFavourites = {[unowned self] in
    //            deletFromFavourites(productID: Int(favProducts[indexPath.item].id ))
    //        }
    //        return cell
    //
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        print("navigate to item \(favProducts[indexPath.row])")
    //    }
    
}
