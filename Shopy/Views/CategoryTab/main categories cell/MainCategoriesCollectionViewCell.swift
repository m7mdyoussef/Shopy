//
//  MainCategoriesCollectionViewCell.swift
//  Shopy
//
//  Created by mohamed youssef on 5/30/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class MainCategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainCategoriesCellLabel: UILabel!
    @IBOutlet weak var mainCategoriesCellHighLightedView: UIView!
    
    
    override var isHighlighted: Bool{
        didSet{
            mainCategoriesCellLabel.textColor = isHighlighted ? UIColor.black : UIColor.gray
            mainCategoriesCellHighLightedView.backgroundColor = isHighlighted ? UIColor.black : UIColor.white
        }
    }
    
    override var isSelected: Bool{
        didSet{
            mainCategoriesCellLabel.textColor = isSelected ? UIColor.black : UIColor.gray
            mainCategoriesCellHighLightedView.backgroundColor = isSelected ? UIColor.black : UIColor.white

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
