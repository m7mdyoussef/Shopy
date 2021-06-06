//
//  SubCategoriesCollectionViewCell.swift
//  Shopy
//
//  Created by mohamed youssef on 5/30/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class SubCategoriesCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var subCatView: UIView!
    @IBOutlet weak var subCategorieslabel: UILabel!
    
    @IBOutlet weak var highLightedView: UIView!
    
    
    override var isHighlighted: Bool{
        didSet{
           // subCategorieslabel.textColor = isHighlighted ? UIColor.black : UIColor.gray
         subCatView.backgroundColor = isHighlighted ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : UIColor.white
            subCategorieslabel.textColor = isHighlighted ? #colorLiteral(red: 1, green: 0.4701387882, blue: 0.4451708794, alpha: 1) : UIColor.gray

        }
    }
    
    override var isSelected: Bool{
        didSet{
            subCategorieslabel.textColor = isSelected ? UIColor.black : UIColor.gray
            subCatView.backgroundColor = isSelected ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : UIColor.white
            subCategorieslabel.textColor = isSelected ? #colorLiteral(red: 1, green: 0.4701387882, blue: 0.4451708794, alpha: 1) : UIColor.gray


        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
