//
//  MainProductsCollectionViewCell.swift
//  Shopy
//
//  Created by mohamed youssef on 5/30/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import SDWebImage

class MainProductsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
    var productObject:ProductElement!{
        didSet{
            productName.text = productObject.title
            productImage.sd_setImage(with: URL(string: productObject.image.src), placeholderImage: UIImage(named: "1"))
        }
    }
    
    var DetailedProductObject:DetailedProducts!{
        didSet{
            productName.text = DetailedProductObject.variants[0].price + " $"
            productName.font = UIFont.boldSystemFont(ofSize: 17)
            productImage.sd_setImage(with: URL(string: DetailedProductObject.image.src), placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.layer.cornerRadius = 20
//        self.layer.borderWidth = 0.5
//        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.collectionCellLayout()
    
    }

}
