//
//  FavouriteproductCVC.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 03/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class FavouriteproductCVC: UICollectionViewCell {
    @IBOutlet weak var collectionViewBackground: UIView!{
        didSet{
            collectionViewBackground.collectionCellLayout()
        }
    }
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    var favProduct : FavouriteProduct? {
        didSet{
            guard let price = favProduct?.price else {return}
            self.productPrice.text = "\(price)$"
            self.productTitle.text = favProduct?.title
            self.productImage.doenloadImage(url: favProduct?.image ?? "")
        }
    }
    var deleteFromFavourites :()->() = {}
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func deleteFromFavourites(_ sender: Any) {
        self.deleteFromFavourites()
    }
    
}
