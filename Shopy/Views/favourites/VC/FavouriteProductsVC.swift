//
//  FavouriteProductsVC.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 03/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class FavouriteProductsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let localData = FavouritesPersistenceManager.shared
        let favourites = localData.retrieveFavourites()
        print("\(favourites?.count)")
    }



}
