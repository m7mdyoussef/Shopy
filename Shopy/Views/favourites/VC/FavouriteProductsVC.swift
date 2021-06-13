//
//  FavouriteProductsVC.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 03/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FavouriteProductsVC: UIViewController {
    @IBOutlet weak var emptyImageView: UIImageView!
    
    @IBOutlet weak var favouriteProductsCollectionView: UICollectionView!{
        didSet{
            //favouriteProductsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        }
    }
    var disposeBag = DisposeBag()
    var favProducts = [FavouriteProduct]()
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.title = "Whish List"
        let favProductCell = UINib(nibName: "FavouriteproductCVC", bundle: nil)
        favouriteProductsCollectionView.register(favProductCell, forCellWithReuseIdentifier: "FavouriteproductCVC")
        
        
        favouriteProductsCollectionView.delegate = self
        favouriteProductsCollectionView.dataSource = self
       fetchFavProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    func fetchFavProducts() {
        let localData = FavouritesPersistenceManager.shared
        guard let favourites = localData.retrieveFavourites() else {
            return
        }
        self.favProducts = favourites
        DispatchQueue.main.async {
            if self.favProducts.isEmpty{
                self.emptyImageView.isHidden = false
                self.favouriteProductsCollectionView.isHidden = true
            }
            else{
                self.emptyImageView.isHidden = true
                self.favouriteProductsCollectionView.isHidden = false
                self.favouriteProductsCollectionView.reloadData()
            }
          
        }
       
    }
    func deletFromFavourites(productID : Int) {
        let localData = FavouritesPersistenceManager.shared
        localData.removeProduct(productID: productID)
        self.fetchFavProducts()
    }

}


extension FavouriteProductsVC :UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteproductCVC", for: indexPath) as! FavouriteproductCVC
        cell.favProduct = favProducts[indexPath.item]
        cell.deleteFromFavourites = {[weak self] in
            self?.deletFromFavourites(productID: Int(self?.favProducts[indexPath.item].id ?? 0))
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 1, bottom: 0, right: 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = (view.frame.width - 2 - 2)/2
        return CGSize(width: availableWidth, height: availableWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
