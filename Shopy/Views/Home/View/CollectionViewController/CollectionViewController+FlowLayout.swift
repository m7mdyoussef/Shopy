//
//  CollectionViewController+FlowLayout.swift
//  Shopy
//
//  Created by SOHA on 5/31/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import UIKit
import ViewAnimator

extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1{
            return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width/3, height: 220)
        }else if menuCollectionView.tag == 0
        {
            return CGSize(width: (self.view.frame.width)/3, height: 30)
        }else{
            return CGSize(width: (self.view.frame.width)/3, height: 30)
        }
    }
    
    func registerProductCell(){
        let productCell = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productsCollectionView.register(productCell, forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
    
    func registerMenuCell(){
        let mainCategoryElementCell = UINib(nibName: Constants.mainCategoryElementCell, bundle: nil)
        menuCollectionView.register(mainCategoryElementCell, forCellWithReuseIdentifier: Constants.mainCategoryElementCell)
    }
    
    func controlViews(flag:Bool){
        if (flag == true){
            adsButton.isHidden = false
            discountCode.isHidden = true
            adsImage.contentMode = .scaleAspectFit
        }else{
            adsButton.isHidden = true
            discountCode.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let animation = AnimationType.zoom(scale: 0)
        cell.animate(animations: [animation],delay: 0.5,duration: 2)
    }
}
