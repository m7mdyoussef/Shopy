//
//  MeVC.swift
//  Shopy
//
//  Created by Amin on 06/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import HMSegmentedControl
import RxSwift
import RxCocoa

class MeVC: UIViewController {
    
    @IBOutlet weak var uiLoggedIn: UIStackView!
    @IBOutlet weak var uiWishlistCollection: UICollectionView!
    @IBOutlet weak var uiEmptyListImage: UIImageView!
    @IBOutlet weak var uiStack: UIStackView!
    
    var viewModel:MeTapViewModel!
    var bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MeTapViewModel()
        registerWishlistCell()
        addingOrdersStatusSegments()
        uiWishlistCollection.rx.setDelegate(self).disposed(by: bag)
        setupWishlistCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        if viewModel.isUserLoggedIn() {
            showGreatingMessage()
            viewModel.favProducts?.drive(onNext: { [unowned self] (favProducts) in
                resetViews(count:favProducts.count)
                uiWishlistCollection.reloadData()
            }).disposed(by: bag)
            viewModel.fetchFavProducts()
        }else{
            let vc = storyboard?.instantiateViewController(identifier: Constants.entryPoint) as! EntryPointVC
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func registerWishlistCell() {
        let favProductCell = UINib(nibName: "FavouriteproductCVC", bundle: nil)
        uiWishlistCollection.register(favProductCell, forCellWithReuseIdentifier: "FavouriteproductCVC")
    }
    
    func addingOrdersStatusSegments() {
        let segmentedControl = HMSegmentedControl(sectionTitles: [
            "Pending",
            "Authorized",
            "Paritally Paid",
            "Paid",
            "Partially Refunded",
            "Refunded",
            "Voided",
        ])
        
        segmentedControl.borderWidth = CGFloat(1)
        segmentedControl.selectionIndicatorColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        segmentedControl.selectionIndicatorLocation = .bottom
        segmentedControl.selectionIndicatorHeight = 2
        uiStack.addArrangedSubview(segmentedControl)
    }
    
    func setupWishlistCollectionView()  {
        viewModel.favProducts?.asObservable().bind(to: uiWishlistCollection.rx.items(cellIdentifier: "FavouriteproductCVC")){
            row,item,cell in
            (cell as? FavouriteproductCVC)?.favProduct = item
            (cell as? FavouriteproductCVC)?.deleteFromFavourites = { [unowned self] in
                deletFromFavourites(productID: Int(item.id ))
            }
            
        }.disposed(by: bag)
        
        
        uiWishlistCollection.rx.itemSelected.subscribe{ value in
            print("tapped")
        }.disposed(by: bag)
    }
    
    func showGreatingMessage() {
        navigationItem.title = "Hello,\(viewModel.getUserName())"
    }
    
    func deletFromFavourites(productID : Int) {
        let localData = FavouritesPersistenceManager.shared
        localData.removeProduct(productID: productID)
        uiWishlistCollection.reloadData()
    }
    
    
    func resetViews(count:Int) {
        if count > 0 {
            uiEmptyListImage.isHidden = true
            uiWishlistCollection.isHidden = false
        }else{
            uiEmptyListImage.isHidden = false
            uiWishlistCollection.isHidden = true
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      //  uiWishlistCollection.reloadData()
    }
}

extension MeVC : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        1
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = CGFloat(10)
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: CGFloat(view.layer.frame.width / 2), height: CGFloat(view.layer.frame.height * 1/4  ))
        return CGSize(width: CGFloat(200), height: CGFloat(view.layer.frame.height * 1/3.5  ))
    }
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return favProductCount
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //
    //        let cell = uiWishlistCollection.dequeueReusableCell(withReuseIdentifier: "FavouriteproductCVC", for: indexPath) as! FavouriteproductCVC
    //
    //        cell.favProduct = favProducts[indexPath.item]
    //        cell.deleteFromFavourites = {[unowned self] in
    //            deletFromFavourites(productID: Int(favProducts[indexPath.item].id ))
    //        }
    //        return cell
    //
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        print("navigate to item \(favProducts[indexPath.row])")
    //    }
    
}
