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
            

            mainCategoriesCellLabel.layer.backgroundColor = isHighlighted ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
         //   mainCatView.backgroundColor = isHighlighted ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : UIColor.white
           mainCategoriesCellHighLightedView.backgroundColor = isHighlighted ? #colorLiteral(red: 0.9649999738, green: 0.6240000129, blue: 0, alpha: 1) : UIColor.white
        }
    }
    
    override var isSelected: Bool{
        didSet{
            mainCategoriesCellLabel.textColor = isSelected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : UIColor.gray
            
         //   mainCatView.backgroundColor = isSelected ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : UIColor.white

            mainCategoriesCellLabel.layer.backgroundColor = isSelected ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            mainCategoriesCellHighLightedView.backgroundColor = isSelected ? #colorLiteral(red: 0.9649999738, green: 0.6240000129, blue: 0, alpha: 1) : UIColor.white
        
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainCategoriesCellLabel.layer.cornerRadius = 8

       // mainCatView.roundCorners(corners: [.topRight,.topLeft], radius: 10)
    }

}
