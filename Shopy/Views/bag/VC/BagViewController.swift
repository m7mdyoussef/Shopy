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
    var viewModel : BagViewModel!
    var bagProducts = [BagProduct]()

    var bag = DisposeBag()
    var hud:JGProgressHUD!
    
    

    var totalPrice:Double = 0
    var totalDiscount:Double = 0
//    let hud = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
//    
//    override func viewDidAppear(_ animated: Bool) {
//        let animation = AnimationType.from(direction: .left, offset: 300)
//        UIView.animate(views: bagProductsCollectionView.visibleCells, animations: [animation],delay: 0.5,duration: 3)
//    }
    
    func emptyBag()  {
        for item in bagProducts{
            deletFromBagProducts(productID: Int(item.id))
        }
        fetchBagProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBagProducts()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func fetchBagProducts() {
        let localData = BagPersistenceManager.shared
        guard let bagProducts = localData.retrievebagProducts() else {return}
        self.bagProducts = bagProducts
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
    func updateCount(productID : Int , count : Int) {
        let localData = BagPersistenceManager.shared
        localData.updateCount(productID: productID, count: count)
       // self.fetchBagProducts()
    }
    func updateTotalPrice() {
        let localData = BagPersistenceManager.shared
        guard let bagProducts = localData.retrievebagProducts() else {return}
        self.bagProducts = bagProducts
//        var totalPrice = 0.0
        
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
//        viewModel.checkout(product: bagProducts)
        showPaymentOptins()
        
    }
    
    
    
    private func showPaymentOptins() {
//        fetchBagProducts()
//        updateTotalPrice()
        let alertController = UIAlertController(title: "Payment Options".localized, message: "Choose prefered payment option".localized, preferredStyle: .actionSheet)
        let vc = UIStoryboard.init(name: "Main".localized, bundle: nil).instantiateViewController(identifier: "cardInfoVC") as! CardInfoViewController
        vc.delegate = self
        
        let discount = MyUserDefaults.getValue(forKey: .isDisconut) as! Bool ? Double(round(1000 * (totalPrice * 0.10) )/1000) : 0
        let obj = OrderObject(products: self.bagProducts, total: totalDiscount, subTotal:totalPrice , discount: discount)
        vc.orderObject = obj
        
        let cardAction = UIAlertAction(title: "Pay with Card".localized, style: .default) { (action) in
            vc.paymentMethod = .stripe
            self.present(vc, animated: true, completion: nil)
        }
        
        let cashOnDelivery = UIAlertAction(title: "Cash on delivery".localized, style: .default) { [weak self] (action) in
            guard let self = self else {return}
            vc.paymentMethod = .cash
            self.present(vc, animated: true, completion: nil)
//            self.viewModel.checkout(product: self.bagProducts,status: .pending)
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
        
//        var itemsToBuy : [PayPalItem] = []
        self.totalPrice = 0
        for item in bagProducts {
            self.totalPrice += Double(item.price!)!
        }
        print(Int(totalPrice))
        self.totalPrice = self.totalPrice * 100
        
        StripeClient.sharedClient.createAndConfirmPayment(token, amount: Int(totalPrice)) { (error) in
            
            if error == nil {
                //self.emptyTheBasket()
               // self.addItemsToPurchaseHistory(self.purchasedItemIds)
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
        cell.updateSavedCount = {[weak self](count , available) in
            if available {
                self?.updateCount(productID: Int(self?.bagProducts[indexPath.item].id ?? 0), count: count)
                self?.fetchBagProducts()
            }
            else{
                self?.presentGFAlertOnMainThread(title: "Error".localized, message: "Sorry , this product isn't available with this amount".localized, buttonTitle: "OK".localized)
            }
        
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 2
//    }
//
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
