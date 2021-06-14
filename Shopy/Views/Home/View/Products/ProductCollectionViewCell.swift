//
//  ProductCollectionViewCell.swift
//  Shopy
//
//  Created by SOHA on 5/28/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.productView.collectionCellLayout()
    }

}
