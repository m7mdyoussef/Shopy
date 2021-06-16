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
            mainCategoriesCellLabel.textColor = isHighlighted ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : UIColor.gray
            

            mainCategoriesCellLabel.layer.backgroundColor = isHighlighted ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.9999235272, green: 1, blue: 0.9998829961, alpha: 1)
         //   mainCatView.backgroundColor = isHighlighted ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : UIColor.white
           mainCategoriesCellHighLightedView.backgroundColor = isHighlighted ? #colorLiteral(red: 0.9631432891, green: 0.6232308745, blue: 0.0003859905701, alpha: 1) : UIColor.white

        }
    }
    
    override var isSelected: Bool{
        didSet{
            mainCategoriesCellLabel.textColor = isSelected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : UIColor.gray
            
         //   mainCatView.backgroundColor = isSelected ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : UIColor.white

            mainCategoriesCellLabel.layer.backgroundColor = isSelected ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.9999235272, green: 1, blue: 0.9998829961, alpha: 1)
            mainCategoriesCellHighLightedView.backgroundColor = isSelected ? #colorLiteral(red: 0.9631432891, green: 0.6232308745, blue: 0.0003859905701, alpha: 1) : UIColor.white
        
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainCategoriesCellLabel.layer.cornerRadius = 8

       // mainCatView.roundCorners(corners: [.topRight,.topLeft], radius: 10)
    }

}
