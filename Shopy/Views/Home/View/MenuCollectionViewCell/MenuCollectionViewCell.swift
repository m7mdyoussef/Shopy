//
//  MenuCollectionViewCell.swift
//  Shopy
//
//  Created by SOHA on 5/28/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    override var isHighlighted: Bool{
        didSet{
           
            mainView.backgroundColor = isHighlighted ?  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            title.textColor = isHighlighted ? #colorLiteral(red: 1, green: 0.2891507945, blue: 0.3121946537, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            menuView.backgroundColor = isHighlighted ? #colorLiteral(red: 0.9985825419, green: 0.2874522209, blue: 0.3107439578, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           // title.highlightedTextColor = isHighlighted ? #colorLiteral(red: 0.9985825419, green: 0.2874522209, blue: 0.3107439578, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    override var isSelected: Bool{
        didSet{
            title.textColor = isSelected ? #colorLiteral(red: 1, green: 0.2891507945, blue: 0.3121946537, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            menuView.backgroundColor = isSelected ? #colorLiteral(red: 1, green: 0.2891507945, blue: 0.3121946537, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           
            mainView.backgroundColor = isHighlighted ?  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
    }
}
