//
//  BagViewController.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 05/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class BagViewController: UIViewController {
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var bagProductsCollectionView: UICollectionView!{
        didSet{
            bagProductsCollectionView.delegate = self
            bagProductsCollectionView.dataSource = self
        }
    }

    var bagProducts = [BagProduct]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Bag Products"
        let favProductCell = UINib(nibName: "BagCollectionViewCell", bundle: nil)
        bagProductsCollectionView.register(favProductCell, forCellWithReuseIdentifier: "BagCollectionViewCell")
       fetchBagProducts()
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
}


extension BagViewController :UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bagProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BagCollectionViewCell", for: indexPath) as! BagCollectionViewCell
        cell.bagProduct = bagProducts[indexPath.item]
        cell.deleteFromBagProducts = {[weak self] in
            self?.deletFromBagProducts(productID: Int(self?.bagProducts[indexPath.item].id ?? 0))
            self?.fetchBagProducts()
         }
        cell.updateSavedCount = {[weak self](count) in
            self?.updateCount(productID: Int(self?.bagProducts[indexPath.item].id ?? 0), count: count)
            self?.fetchBagProducts()
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
