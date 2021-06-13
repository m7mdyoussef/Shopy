//
//  SizesCollectionViewCell.swift
//  Shopy
//
//  Created by SOHA on 6/2/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class SizesCollectionViewCell: UICollectionViewCell {

  
    @IBOutlet weak var productSize: UILabel!
    
    override var isHighlighted: Bool{
        didSet{
            productSize.textColor = isHighlighted ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            productSize.layer.backgroundColor = isHighlighted ? #colorLiteral(red: 1, green: 0.4701387882, blue: 0.4451708794, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    override var isSelected: Bool{
        didSet{
            productSize.textColor = isSelected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            productSize.layer.backgroundColor = isSelected ? #colorLiteral(red: 1, green: 0.4701387882, blue: 0.4451708794, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        productSize.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        productSize.viewBorderWidth = 0.5
        productSize.viewBorderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        productSize.layer.borderWidth = 0.5
        productSize.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        productSize.layer.cornerRadius = 8
    }

}
