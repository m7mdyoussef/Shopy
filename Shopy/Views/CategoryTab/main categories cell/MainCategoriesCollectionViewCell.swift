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
    
    @IBOutlet weak var mainCatView: UIView!
    
    override var isHighlighted: Bool{
        didSet{
            mainCategoriesCellLabel.textColor = isHighlighted ? #colorLiteral(red: 1, green: 0.4701387882, blue: 0.4451708794, alpha: 1) : UIColor.gray
            

            mainCatView.backgroundColor = isHighlighted ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : UIColor.white
            
            mainCategoriesCellHighLightedView.backgroundColor = isHighlighted ? #colorLiteral(red: 1, green: 0.4701387882, blue: 0.4451708794, alpha: 1) : UIColor.white
        }
    }
    
    override var isSelected: Bool{
        didSet{
            mainCategoriesCellLabel.textColor = isSelected ? #colorLiteral(red: 1, green: 0.4701387882, blue: 0.4451708794, alpha: 1) : UIColor.gray
            
            mainCatView.backgroundColor = isSelected ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : UIColor.white


            mainCategoriesCellHighLightedView.backgroundColor = isSelected ? #colorLiteral(red: 1, green: 0.4701387882, blue: 0.4451708794, alpha: 1) : UIColor.white

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainCatView.roundCorners(corners: [.topRight,.topLeft], radius: 10)
    }

}
