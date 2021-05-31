//
//  SubCategoriesCollectionViewCell.swift
//  Shopy
//
//  Created by mohamed youssef on 5/30/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class SubCategoriesCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var subCategorieslabel: UILabel!
    
    @IBOutlet weak var highLightedView: UIView!
    
    
    override var isHighlighted: Bool{
        didSet{
            subCategorieslabel.textColor = isHighlighted ? UIColor.black : UIColor.gray
            highLightedView.backgroundColor = isHighlighted ? UIColor.black : UIColor.white
        }
    }
    
    override var isSelected: Bool{
        didSet{
            subCategorieslabel.textColor = isSelected ? UIColor.black : UIColor.gray
            highLightedView.backgroundColor = isSelected ? UIColor.black : UIColor.white

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
