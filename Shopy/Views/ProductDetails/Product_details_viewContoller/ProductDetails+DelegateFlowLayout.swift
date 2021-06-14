//
//  ProductDetails+DelegateFlowLayout.swift
//  Shopy
//
//  Created by SOHA on 6/4/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import UIKit
extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width)/4, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func registerSizeCell(){
        let sizeCell = UINib(nibName: "SizesCollectionViewCell", bundle: nil)
        sizeCollectionView.register(sizeCell, forCellWithReuseIdentifier: "SizesCollectionViewCell")
    }
    
    func checkFav(){
        if self.isFavo == false{
            self.presentGFAlertOnMainThread(title: "Completed".localized, message: "Successfully added to the whishlist🎉🎉".localized, buttonTitle: "OK".localized)
            favouriteButton.tintColor = UIColor.red
            self.manager.addToFavourites(favProduct: self.productElement!)
        }else{
            self.presentGFAlertOnMainThread(title: "Completed".localized, message: "Successfully removed from the whishlist".localized, buttonTitle: "OK".localized)
            favouriteButton.tintColor = UIColor.gray
            self.manager.removeProduct(productID: self.productElement!.id)
        }
    }
}
