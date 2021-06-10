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
        return CGSize(width: (self.view.frame.width)/5, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func registerSizeCell(){
        var sizeCell = UINib(nibName: "SizesCollectionViewCell", bundle: nil)
        sizeCollectionView.register(sizeCell, forCellWithReuseIdentifier: "SizesCollectionViewCell")
    }
    
    func checkFav(){
        if self.isFavo == false{
            self.presentGFAlertOnMainThread(title: "Success", message: "Successfully added to the whishlist🎉🎉", buttonTitle: "OK")
            favouriteButton.tintColor = UIColor.red
            self.manager.addToFavourites(favProduct: self.productElement!)
        }else{
            self.presentGFAlertOnMainThread(title: "Success", message: "Successfully removed from the whishlist", buttonTitle: "OK")
            favouriteButton.tintColor = UIColor.gray
            self.manager.removeProduct(productID: self.productElement!.id)
        }
    }
}
