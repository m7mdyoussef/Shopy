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
import BadgeHub
import ViewAnimator
import MOLH

class MeVC: UIViewController {
    
    @IBOutlet weak var uiWishlistCollection: UICollectionView!
    @IBOutlet weak var uiOrdersCollection: UICollectionView!
    @IBOutlet weak var uiEmptyWishListImage: UIImageView!
    @IBOutlet weak var uiEmptyOrdersListImage: UIImageView!
    @IBOutlet weak var uiStack: UIStackView!
    @IBOutlet weak var uiOrderCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var uiRemoveAllOrders: UIButton!
    
    @IBOutlet weak var favouriteBtn: UIBarButtonItem!
    @IBOutlet weak var bagBtn: UIBarButtonItem!
    var hubBag: BadgeHub!
    var hubFavourite: BadgeHub!
    let manager = FavouritesPersistenceManager.shared
    let bagManager = BagPersistenceManager.shared
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if uiWishlistCollection.isHidden == false{
             let animation = AnimationType.from(direction: .left, offset: 300)
             UIView.animate(views: uiWishlistCollection.visibleCells, animations: [animation],delay: 0.5,duration: 2)
             
             let animation1 = AnimationType.random()
             UIView.animate(views: uiOrdersCollection.visibleCells,animations: [animation1],delay: 0.5,duration: 2)
//         }
     }
    
    @IBAction func uiSettings(_ sender: Any) {
        //        let settings = SettingsVC()
        //        navigationController?.pushViewController(settings, animated: true)
        
//        let alert = UIAlertController(title: "Settings".localized, message: "", preferredStyle: .actionSheet)
//        let lang = UIAlertAction(title: "Language".localized, style: .default) { (action) in
//
//
//            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
//            if #available(iOS 13.0, *) {
//                let delegate = UIApplication.shared.delegate as? AppDelegate
//                delegate!.swichRoot()
//
//            } else {
//                // Fallback on earlier versions
//                MOLH.reset()
//            }
//
//        }
//        let status = viewModel.isUserLoggedIn() ? "Logout".localized : "Login".localized
//        let logoutaction = UIAlertAction(title: status, style: .destructive) { [weak self] (action) in
//            guard let self = self else {return}
//
//            if status == "Login".localized{
//                let vc = self.storyboard?.instantiateViewController(identifier: "EntryPointVC") as! EntryPointVC
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true, completion: nil)
//            }else{
//                let logout = UIAlertController(title: "Logout".localized, message: "Are you sure ?".localized, preferredStyle: .alert)
//                let ok = UIAlertAction(title: "OK".localized, style: .destructive) { (action) in
//                    self.viewModel.logout()
//                    self.tabBarController?.selectedIndex = 0
//                    self.viewModel.fetchFavProducts()
//                    self.viewModel.fetchOrders()
//
//                }
//
//                let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                logout.addAction(ok)
//                logout.addAction(cancel)
//                self.present(logout, animated: true, completion: nil)
//            }
//        }
//
//        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//        alert.addAction(lang)
//        alert.addAction(logoutaction)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)
        let vc = storyboard?.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
        navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)

        //Master
//        let alert = UIAlertController(title: "Settings".localized, message: "", preferredStyle: .actionSheet)
//        let lang = UIAlertAction(title: "Language".localized, style: .default) { (action) in
//
//
//            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
//            if #available(iOS 13.0, *) {
//                let delegate = UIApplication.shared.delegate as? AppDelegate
//                delegate!.swichRoot()
//
//            } else {
//                // Fallback on earlier versions
//                MOLH.reset()
//            }
//
//        }
//        let status = viewModel.isUserLoggedIn() ? "Logout".localized : "Login".localized
//        let logoutaction = UIAlertAction(title: status, style: .destructive) { [weak self] (action) in
//            guard let self = self else {return}
//
//            if status == "Login".localized{
//                let vc = self.storyboard?.instantiateViewController(identifier: "EntryPointVC") as! EntryPointVC
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true, completion: nil)
//            }else{
//                let logout = UIAlertController(title: "Logout".localized, message: "Are you sure ?".localized, preferredStyle: .alert)
//                let ok = UIAlertAction(title: "OK".localized, style: .destructive) { (action) in
//                    self.viewModel.logout()
//                    self.tabBarController?.selectedIndex = 0
//                    self.viewModel.fetchFavProducts()
//                    self.viewModel.fetchOrders()
//
//                }
//
//                let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                logout.addAction(ok)
//                logout.addAction(cancel)
//                self.present(logout, animated: true, completion: nil)
//            }
//        }
//
//        let editProfile = UIAlertAction(title: "Edit Profile", style: .default) { [weak self] (_) in
//            guard let self = self else {return}
//            let vc = self.storyboard?.instantiateViewController(identifier: "Register") as! Register
//
//            self.viewModel.getCustomerData { (customer,id) in
//                vc.customer = customer
//                vc.customerID = id
//                self.present(vc, animated: true, completion: nil)
//            } onError: {
//                vc.customer = nil
//                self.present(vc, animated: true, completion: nil)
//            }
//        }
//
//        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//        alert.addAction(lang)
//        alert.addAction(logoutaction)
//        alert.addAction(editProfile)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)
    }
    
    func setupViews()  {
        registerCollectionViewCells()
        //        addingOrdersStatusSegments()
        setupWishlistCollectionView()
        setupOrdersCollectionView()
        uiWishlistCollection.rx.setDelegate(self).disposed(by: bag)
        uiOrdersCollection.rx.setDelegate(self).disposed(by: bag)
        
        viewModel.loadingObservable.asObservable().subscribe{ [unowned self] value in
            guard let value = value.element else {return}
            if value {
                self.hud = self.loadingHud(text: "Loading".localized, style: .dark)
                self.view.isUserInteractionEnabled = false
            }else{
                self.dismissLoadingHud(hud: self.hud)
                self.view.isUserInteractionEnabled = true
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
        //        let financialState = sgmentsArray[Int(segmentedControl.selectedSegmentIndex)].state
        viewModel.fetchOrders()
    }
    
    func setupWishlistCollectionView() {
        viewModel.favProductsObservable?.asObservable().bind(to: uiWishlistCollection.rx.items(cellIdentifier: "FavouriteproductCVC")){
            row,item,cell in
            (cell as? FavouriteproductCVC)?.favProduct = item
            (cell as? FavouriteproductCVC)?.deleteFromFavourites = { [unowned self] in
                let alert = UIAlertController(title: "Remove Favourite".localized, message: "Are you sure you want to remove the product from the wishlist ?".localized, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Yes".localized, style: .destructive) { (action) in
                    self.deletFromFavourites(productID: Int(item.id ))
                    self.viewModel.fetchFavProducts()
                    self.uiWishlistCollection.reloadData()
                }
                let action2 = UIAlertAction(title: "Cancel".localized, style: .default, handler: nil)
                
                alert.addAction(action)
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
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
        

        uiOrdersCollection.rx.modelSelected(Order.self).subscribe{ [unowned self] value in
            let vc = self.storyboard?.instantiateViewController(identifier: "OrderDetailsVC") as! OrderDetailsVC
            vc.order = value.element
            
            if AppCommon.shared.checkConnectivity() == true{
                self.present(vc, animated: true, completion: nil)
            }
            
        }.disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)

        uiOrdersCollection.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        
        if AppCommon.shared.checkConnectivity() == false{
            let NoInternetViewController = self.storyboard?.instantiateViewController(identifier: "NoInternetViewController") as! NoInternetViewController
            NoInternetViewController.modalPresentationStyle = .fullScreen
            self.present(NoInternetViewController, animated: true, completion: nil)
            
        }else{
            
            showGreatingMessage()
            if viewModel.isUserLoggedIn() {
                bagBtn.setBadge(text: String(describing: bagManager.retrievebagProducts()?.count ?? 0))
                viewModel.favProductsObservable?.drive(onNext: { [unowned self] (favProducts) in
                    self.resetWishListViews(count:favProducts.count)
                    self.uiWishlistCollection.reloadData()
                }).disposed(by: bag)
                
                viewModel.ordersObservable?.drive(onNext: { [unowned self] (orders) in
                    self.uiOrdersCollection.reloadData()
                    self.resetOrdersListViews(count: orders.count)
                }).disposed(by: bag)
                
                viewModel.fetchFavProducts()
                fetchOrders()
            }
//            else{
//                bagBtn.setBadge(text: String("0"))
//                let vc = storyboard?.instantiateViewController(identifier: Constants.entryPoint) as! EntryPointVC
//                vc.modalPresentationStyle = .fullScreen
//                present(vc, animated: true, completion: nil)
//            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        uiOrdersCollection.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                self.uiOrderCollectionHeight.constant = newSize.height
            }
        }
    }
    
    func showGreatingMessage() {
       
        if  viewModel.getUserName() == nil  || viewModel.getUserName() == ""{
            navigationItem.title = "Login / Register".localized
        }else{
            navigationItem.title = "\("Hello".localized),\(String(describing: viewModel.getUserName()!))"
        }
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
            uiRemoveAllOrders.isHidden = false
        }else{
            uiEmptyOrdersListImage.isHidden = false
            uiOrdersCollection.isHidden = true
            uiRemoveAllOrders.isHidden = true
        }
    }
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        uiWishlistCollection.reloadData()
//    }
    
    @IBAction func uiCardButton(_ sender: Any) {
        
        if viewModel.isUserLoggedIn(){
            let bag = BagViewController()
            navigationController?.pushViewController(bag, animated: true)
        }else{
            let vc = storyboard?.instantiateViewController(identifier: Constants.entryPoint) as! EntryPointVC
                vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func uiRemoveAllOrders(_ sender: Any) {
        let alert = UIAlertController(title: "Remove All Orders".localized, message: "Are you Sure you want to remove all orders".localized, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Yes".localized, style: .destructive) { [weak self] (action) in
            guard let self = self else {return}
            self.viewModel.removeAllOrders { [weak self] in
                guard let self = self else {return}
                self.resetOrdersListViews(count: 0)
            }
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}

extension MeVC : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        1
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch collectionView {
        case uiWishlistCollection:
            let inset = CGFloat(10)
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
        case uiOrdersCollection:
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return CGSize(width: CGFloat(view.layer.frame.width / 2), height: CGFloat(view.layer.frame.height * 1/4  ))
        
        if collectionView == uiWishlistCollection{
            return CGSize(width: CGFloat(200), height: CGFloat(view.layer.frame.height * 1/3.5  ))
        }else {
            return CGSize(width: CGFloat(150), height: CGFloat(200))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        var animation :AnimationType
        
        switch collectionView {
        case uiWishlistCollection:
            animation = AnimationType.from(direction: .top, offset: 300)
        default:
            animation = AnimationType.zoom(scale: 0)
        }
        cell.animate(animations: [animation],delay: 0.5,duration: 2)
    }
    
}


