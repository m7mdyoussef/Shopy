//
//  MenuViewController.swift
//  Shopy
//
//  Created by SOHA on 5/28/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MenuViewController: UIViewController{
    
    var arrId = [Int]()
    @IBOutlet weak var menuCollectionView: UICollectionView!
    var collectionViewModel:HomeModelType?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewModel = HomeViewModel()
        collectionViewModel?.getCollectionData()
        regicterCell()
        
        collectionViewModel?.collectionDataObservable?.asObservable().bind(to: menuCollectionView.rx.items(cellIdentifier: "MenuCollectionViewCell")){row, items, cell in
            (cell as? MenuCollectionViewCell)?.title.text=items.title
            self.arrId.append(items.id)
            
        }
        
        menuCollectionView.rx.setDelegate(self)
        
        menuCollectionView.rx.itemSelected.subscribe{value in
            print(self.arrId[value.element?.item ?? 0])
            self.collectionViewModel?.getAllProduct(id: String(self.arrId[value.element?.item ?? 0]))
        }
        }

    
    
    func regicterCell(){
       var menuCell = UINib(nibName: "MenuCollectionViewCell", bundle: nil)
        menuCollectionView.register(menuCell, forCellWithReuseIdentifier: "MenuCollectionViewCell")
    }
}

extension MenuViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width/3, height: 35)
    }
    
}

