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

class CollectionViewController: UIViewController {

    var collectionViewModel:HomeViewModel?
    @IBOutlet weak var productsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewModel = HomeViewModel()
        collectionViewModel?.getCollectionData()
        collectionViewModel?.getAllProduct()
        self.navigationController?.isNavigationBarHidden = true
        registerCell()
    }
    
    func registerCell(){
        var productCell = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        productsCollectionView.register(productCell, forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }


}

extension CollectionViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        cell.productPrice.text = "56468"
        cell.productImage.image=UIImage(named: "1")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width/3, height: 180)
    }
    
    
}
