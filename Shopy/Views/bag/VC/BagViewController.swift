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


class BagViewController: UIViewController {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var uiEmptyImage: UIImageView!
    @IBOutlet weak var afterDiscountLabel: UILabel!
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
        navigationItem.title = "Bag Products"
        let favProductCell = UINib(nibName: "BagCollectionViewCell", bundle: nil)
      //  checkoutView.collectionCellLayout()
        bagProductsCollectionView.register(favProductCell, forCellWithReuseIdentifier: "BagCollectionViewCell")
        
        viewModel.loading.asObservable().subscribe{ [weak self] value in
            guard let self = self else {return}
            print(value.element!)
            
            if value.element == true {
                self.hud = self.loadingHud(text: "Please Wait", style: .dark)
            }else{
                self.dismissLoadingHud(hud: self.hud)
                self.onSuccessHud()
                self.emptyBag()
            }
        }.disposed(by: bag)
        
        viewModel.error.asObservable().subscribe{[weak self] value in
            guard let self = self else {return}
            self.onFaildHud(text: "An Error Occured, Try Again later ...")
        }.disposed(by: bag)
        
    }
    
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
        var totalPrice = 0.0
        
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
                let discount = MyUserDefaults.getValue(forKey: .isDisconut) as! Bool
                if discount == true{
                    self.totalPriceLabel.text = "\(totalPrice) LE"
                    self.totalDiscount = totalPrice - (totalPrice * 0.10)
                    self.afterDiscountLabel.text = "\(self.totalDiscount) LE"
                }else{
                    self.totalDiscount = self.totalPrice
                    self.totalPriceLabel.text = "\(totalPrice) LE"
                    self.afterDiscountLabel.text = "\(totalPrice) LE"
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
        updateTotalPrice()
        let alertController = UIAlertController(title: "Payment Options", message: "Choose prefered payment option", preferredStyle: .actionSheet)
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "cardInfoVC") as! CarInfoViewController
        vc.delegate = self
        
        let discount = MyUserDefaults.getValue(forKey: .isDisconut) as! Bool ? Double(round(1000 * (totalPrice * 0.10) )/1000) : 0
        let obj = OrderObject(products: self.bagProducts, total: totalDiscount, subTotal:totalPrice , discount: discount)
        vc.orderObject = obj
        
        let cardAction = UIAlertAction(title: "Pay with Card", style: .default) { (action) in
            vc.paymentMethod = .stripe
            self.present(vc, animated: true, completion: nil)
        }
        
        let cashOnDelivery = UIAlertAction(title: "Cash on delivery", style: .default) { [weak self] (action) in
            guard let self = self else {return}
            vc.paymentMethod = .cash
            self.present(vc, animated: true, completion: nil)
//            self.viewModel.checkout(product: self.bagProducts,status: .pending)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
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
                self.showNotification(text: "Payment Successful", isError: false)
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
            let alert = UIAlertController(title: "Confirmatiom", message: "Do you want to delete it?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Yes", style: .destructive) { _ in
                self.deletFromBagProducts(productID: Int(self.bagProducts[indexPath.item].id ))
                self.fetchBagProducts()
            }
            let no = UIAlertAction(title: "No", style: .default) { _ in
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
                self?.presentGFAlertOnMainThread(title: "Error", message: "Sorry , this product isn't available with this amount", buttonTitle: "OK")
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
        showNotification(text: "you canceled the payment", isError: true)
    }
    
    func clearBag() {
        emptyBag()
    }
    
}
