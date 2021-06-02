//
//  SizesCollectionViewCell.swift
//  Shopy
//
//  Created by SOHA on 6/2/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class SizesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productSizeView: UIView!
    @IBOutlet weak var productSize: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productSizeView.collectionCellLayout()
    }

}
