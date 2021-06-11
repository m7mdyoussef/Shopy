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

class BagViewController: UIViewController {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutView: UIView!
    
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
            self.bagProductsCollectionView.reloadData()
            self.totalPriceLabel.text = "\(totalPrice) $"
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
        var totalPrice = 0.0
        
        for bag in bagProducts {
            let count = Double(bag.count)
            let price = Double(bag.price ?? "0.0")
            
            totalPrice += price! * count
            
        }
        print("\(totalPrice)")
        DispatchQueue.main.async {
            self.totalPriceLabel.text = "\(totalPrice) $"
        }
       
    }
    
    @IBAction func uiCheckout(_ sender: Any) {
        viewModel.checkout(product: bagProducts)
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
