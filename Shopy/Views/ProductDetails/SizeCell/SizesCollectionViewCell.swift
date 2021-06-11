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
    
    override var isHighlighted: Bool{
        didSet{
            productSize.textColor = isHighlighted ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : UIColor.gray
            productSize.layer.backgroundColor = isHighlighted ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            productSizeView.backgroundColor = isHighlighted ? #colorLiteral(red: 1, green: 0.4701387882, blue: 0.4451708794, alpha: 1) : UIColor.white
        }
    }
    
    override var isSelected: Bool{
        didSet{
            productSize.textColor = isSelected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : UIColor.gray
            productSize.layer.backgroundColor = isSelected ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            productSizeView.backgroundColor = isSelected ? #colorLiteral(red: 1, green: 0.4701387882, blue: 0.4451708794, alpha: 1) : UIColor.white

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productSizeView.collectionCellLayout()
       // productSizeView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
    }

}
