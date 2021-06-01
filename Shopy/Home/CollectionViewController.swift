//
//  CollectionViewController.swift
//  Shopy
//
//  Created by SOHA on 5/28/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage
class CollectionViewController: UIViewController {

    var collectionViewModel:HomeViewModel?
    @IBOutlet weak var productsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        registerCell()
        collectionViewModel = HomeViewModel()
       // collectionViewModel?.getCollectionData()
        collectionViewModel?.getCollectionData()
        collectionViewModel?.getAllProduct(id: "268359598278")
        collectionViewModel?.productsDataObservable?.asObservable().bind(to: productsCollectionView.rx.items(cellIdentifier: "ProductCollectionViewCell")){
            row, item, cell in
            (cell as? ProductCollectionViewCell)?.productPrice.text = item.title
            (cell as? ProductCollectionViewCell)?.productImage.sd_setImage(with: URL(string: item.image.src), completed: nil)
            
        }
        
        productsCollectionView.rx.setDelegate(self)
       
        
    }
    
    func registerCell(){
        var productCell = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productsCollectionView.register(productCell, forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width/3, height: 180)
    }
    
    
}

