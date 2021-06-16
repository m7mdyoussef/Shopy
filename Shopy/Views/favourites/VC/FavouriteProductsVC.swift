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
        cell.deleteFromFavourites = { [unowned self] in
            let alert = UIAlertController(title: "Remove Favourite".localized, message: "Are you sure you want to remove the product from the wishlist ?".localized, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Yes".localized, style: .destructive) { (action) in
                self.deletFromFavourites(productID: Int( favProducts[indexPath.row].id))
                self.fetchFavProducts()
                collectionView.reloadData()
            }
            let action2 = UIAlertAction(title: "Cancel".localized, style: .default, handler: nil)
            
            alert.addAction(action)
            alert.addAction(action2)
            self.present(alert, animated: true, completion: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width / 2.4
        return CGSize(width: availableWidth, height: availableWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.idProduct = String(favProducts[indexPath.row].id)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
    
}
