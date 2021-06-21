//
//  BagViewController.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 05/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import RxSwift
import JGProgressHUD
import Stripe
import ViewAnimator


class BagViewController: UIViewController {
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var uiEmptyImage: UIImageView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var bagProductsCollectionView: UICollectionView!{
        didSet{
            bagProductsCollectionView.delegate = self
            bagProductsCollectionView.dataSource = self
        }
    }
    enum Mode {
        case view
        case selection
    }
    
    var selectedIndexPathDictionaries : [IndexPath:Bool] = [:]
    var currentMode : Mode = .view{
        didSet{
            switch currentMode {
            case .view:
                for (key , value) in selectedIndexPathDictionaries{
                    if value {
                        bagProductsCollectionView.deselectItem(at: key, animated: true)
                    }
                }
                selectedIndexPathDictionaries.removeAll()
                selectBarButton.title = "Select".localized
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.hidesBackButton = false
                //   navigationItem.leftBarButtonItem = nil
                bagProductsCollectionView.allowsMultipleSelection = false
            case .selection:
                selectBarButton.title = "Cancel".localized
                navigationItem.leftBarButtonItem = deleteBarButton
                navigationItem.leftBarButtonItem?.isEnabled = false
                //                navigationItem.leftBarButtonItem = deleteBarButton
                bagProductsCollectionView.allowsMultipleSelection = true
            }
            
        }
    }
    
    lazy var selectBarButton : UIBarButtonItem={
        let item = UIBarButtonItem(title: "Select".localized, style: .plain, target: self, action: #selector(selectionButtonAction))
        return item
    }()
    
    @objc func selectionButtonAction(){
        currentMode = currentMode == .selection ? .view : .selection
    }
    
    lazy var deleteBarButton : UIBarButtonItem={
        let item = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletionButtonAction))
        return item
    }()
    
    @objc func deletionButtonAction(){
        let alert = UIAlertController(title: "Confirmatiom".localized, message: "Do you want to delete it?".localized, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes".localized, style: .destructive) { _ in
            var deletedIndexPath : [IndexPath] = []
            for (key , value) in self.selectedIndexPathDictionaries{
                if value {
                    deletedIndexPath.append(key)
                }
            }
            
            for i in deletedIndexPath.sorted(by: {$0.item>$1.item}){
                self.deletFromBagProducts(productID: Int(self.bagProducts[i.item].id ))
            }
            
            self.currentMode = .view
            self.selectedIndexPathDictionaries.removeAll()
        }
        let no = UIAlertAction(title: "No".localized, style: .default) { _ in
        }
        
        alert.addAction(no)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    var viewModel : BagViewModel!
    var bagProducts = [BagProduct]()
    
    var bag = DisposeBag()
    var hud:JGProgressHUD!
    
    
    
    var totalPrice:Double = 0
    var totalDiscount:Double = 0
    //    let hud = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        viewModel = BagViewModel()
        navigationItem.title = "Bag Products".localized
        let favProductCell = UINib(nibName: "BagCollectionViewCell", bundle: nil)
        //  checkoutView.collectionCellLayout()
        bagProductsCollectionView.register(favProductCell, forCellWithReuseIdentifier: "BagCollectionViewCell")
        checkoutButton.layer.cornerRadius = 15
        checkoutButton.clipsToBounds = true
        viewModel.loading.asObservable().subscribe{ [weak self] value in
            guard let self = self else {return}
            print(value.element!)
            
            if value.element == true {
                self.hud = self.loadingHud(text: "Please Wait".localized, style: .dark)
            }else{
                self.dismissLoadingHud(hud: self.hud)
                self.onSuccessHud()
                self.emptyBag()
            }
        }.disposed(by: bag)
        
        viewModel.error.asObservable().subscribe{[weak self] value in
            guard let self = self else {return}
            self.onFaildHud(text: "An Error Occured, Try Again later ...".localized)
        }.disposed(by: bag)
        
    }
    
    func setUpNavigationBar(){
        navigationItem.rightBarButtonItem = selectBarButton
    }
    
    
    func emptyBag()  {
        for item in bagProducts{
            deletFromBagProducts(productID: Int(item.id))
        }
        fetchBagProducts()
    }
    
    func handleMultipleSelectionLabel(){
        if bagProducts.isEmpty{
            selectBarButton.isEnabled = false
        }else{
            selectBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBagProducts()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let backButton = UIBarButtonItem(title: "Back".localized, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
                self.navigationItem.backBarButtonItem = backButton
    }
    
    func fetchBagProducts() {
        let localData = BagPersistenceManager.shared
        guard let bagProducts = localData.retrievebagProducts() else {return}
        self.bagProducts = bagProducts
        
        handleMultipleSelectionLabel()
        
        totalPrice = 0.0
        
        for bag in bagProducts {
            let count = Double(bag.count)
            let price = Double(bag.price ?? "0.0")
            
            totalPrice += price! * count
            
        }
        DispatchQueue.main.async {
            
            if !bagProducts.isEmpty {
                
                self.uiEmptyImage.isHidden = true
                self.bagProductsCollectionView.isHidden = false
                
                self.bagProductsCollectionView.reloadData()
                
                var discount = false
                if let has = MyUserDefaults.getValue(forKey: .isDisconut) {
                    discount = has as! Bool == true ? true : false
                }else{
                    MyUserDefaults.add(val: false, key: .isDisconut)
                }
                
                if discount == true{
                    self.totalPriceLabel.text = "$ \(self.totalPrice)"
                    self.totalDiscount = self.totalPrice - (self.totalPrice * 0.10)
                }else{
                    self.totalDiscount = self.totalPrice
                    self.totalPriceLabel.text = "$ \(self.totalPrice)"
                }
            }else{
                self.uiEmptyImage.isHidden = false
                self.bagProductsCollectionView.isHidden = true
            }
        }
    }
    func deletFromBagProducts(productID : Int) {
        let localData = BagPersistenceManager.shared
        localData.removeFromBag(productID: productID)
        self.fetchBagProducts()
    }
    func updateCount(productID : Int , count : Int ,size:String) {
        let localData = BagPersistenceManager.shared
        localData.updateCount(productID: productID, count: count,size: size)
    }
    func updateTotalPrice() {
        let localData = BagPersistenceManager.shared
        guard let bagProducts = localData.retrievebagProducts() else {return}
        self.bagProducts = bagProducts
        
        for bag in bagProducts {
            let count = Double(bag.count)
            let price = Double(bag.price ?? "0.0")
            
            totalPrice += price! * count
            
        }
        print("\(totalPrice)")
        DispatchQueue.main.async {
            self.totalPriceLabel.text = "\(self.totalPrice) $"
        }
        
    }
    
    @IBAction func uiCheckout(_ sender: Any) {
        showPaymentOptins()
        
    }
    
    private func showPaymentOptins() {
        
        if AppCommon.shared.checkConnectivity() == false{
            let NoInternetViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NoInternetViewController") as! NoInternetViewController
            NoInternetViewController.modalPresentationStyle = .fullScreen
            self.present(NoInternetViewController, animated: true, completion: nil)
            
        }else{
            let alertController = UIAlertController(title: "Payment Options".localized, message: "Choose prefered payment option".localized, preferredStyle: .actionSheet)
            let vc = UIStoryboard.init(name: "Main".localized, bundle: nil).instantiateViewController(identifier: "cardInfoVC") as! CartInfoViewController
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            
            let discount = MyUserDefaults.getValue(forKey: .isDisconut) as! Bool ? Double(round(1000 * (totalPrice * 0.10) )/1000) : 0
            let obj = OrderObject(products: self.bagProducts, total: totalDiscount, subTotal:totalPrice , discount: discount)
            vc.orderObject = obj
           
                let cardAction = UIAlertAction(title: "Pay with Card".localized, style: .default) { (action) in
                    vc.paymentMethod = .stripe
                    if AppCommon.shared.checkConnectivity() == true {
                    self.present(vc, animated: true, completion: nil)
                }
            }
          
            let cashOnDelivery = UIAlertAction(title: "Cash on delivery".localized, style: .default) { [weak self] (action) in
                guard let self = self else {return}
                vc.paymentMethod = .cash
                if AppCommon.shared.checkConnectivity() == true {
                self.present(vc, animated: true, completion: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { [weak self] (_) in
                guard let self = self else {return}
                self.fetchBagProducts()
            }
            
            alertController.addAction(cardAction)
            alertController.addAction(cancelAction)
            alertController.addAction(cashOnDelivery)
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    private func showNotification(text: String, isError: Bool) {
        hud = JGProgressHUD(style: .dark)
        if isError {
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        } else {
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        
        self.hud.textLabel.text = text
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func finishPayment(token: STPToken){
        self.totalPrice = 0
        for item in bagProducts {
            self.totalPrice += Double(item.price!)!
        }
        print(Int(totalPrice))
        self.totalPrice = self.totalPrice * 100
        
        StripeClient.sharedClient.createAndConfirmPayment(token, amount: Int(totalPrice)) { (error) in
            
            if error == nil {
                self.showNotification(text: "Payment Successful".localized, isError: false)
            } else {
                self.showNotification(text: error!.localizedDescription, isError: true)
                print("error gegdgjgdjjhgejgfjhghrgjdhegejgfjegdjhgejfgjdhgjf ", error!.localizedDescription)
            }
        }
    }
}

extension BagViewController :UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bagProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BagCollectionViewCell", for: indexPath) as! BagCollectionViewCell
        cell.bagProduct = bagProducts[indexPath.item]
        cell.deleteFromBagProducts = {[weak self] in
            guard let self = self else {return}
            let alert = UIAlertController(title: "Confirmatiom".localized, message: "Do you want to delete it?".localized, preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes".localized, style: .destructive) { _ in
                self.deletFromBagProducts(productID: Int(self.bagProducts[indexPath.item].id ))
                self.fetchBagProducts()
            }
            let no = UIAlertAction(title: "No".localized, style: .default) { _ in
            }
            
            alert.addAction(no)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        cell.updateSavedCount = {[weak self](count , available,size) in
            if available {
                self?.updateCount(productID: Int(self?.bagProducts[indexPath.item].id ?? 0), count: count,size: size)
                self?.fetchBagProducts()
            }
            else{
                self?.presentGFAlertOnMainThread(title: "Error".localized, message: "Sorry , this product isn't available with this amount".localized, buttonTitle: "OK".localized)
            }
            
        }
        return cell
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bagProductsCollectionView.collectionViewLayout.invalidateLayout()
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 2, bottom: 0, right: 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = (view.frame.width - 4)
        return CGSize(width: availableWidth, height: availableWidth/2.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentMode {
        case .view:
            bagProductsCollectionView.deselectItem(at: indexPath, animated: true)
        case .selection:
            selectedIndexPathDictionaries[indexPath] = true
            
            if selectedIndexPathDictionaries.isEmpty{
                navigationItem.leftBarButtonItem?.isEnabled = false
            }else{
                navigationItem.leftBarButtonItem?.isEnabled = true
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch currentMode {
        case .view:
            break
        case .selection:
            selectedIndexPathDictionaries[indexPath] = nil
            if selectedIndexPathDictionaries.isEmpty{
                navigationItem.leftBarButtonItem?.isEnabled = false
            }else{
                navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
    }
    
}


extension BagViewController: CardInfoViewControllerDelegate {
    func didClickDone(_ token: STPToken) {
        print("we have a token ", token)
        finishPayment(token: token)
    }
    
    func didClickCancel() {
        print("user canceled the payment")
        showNotification(text: "you canceled the payment".localized, isError: true)
    }
    
    func clearBag() {
        emptyBag()
        self.showNotification(text: "Order Placed Successful".localized, isError: false)
    }
    
}
