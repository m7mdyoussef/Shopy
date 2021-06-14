//
//  CollectionViewCell.swift
//  Shopy
//
//  Created by Amin on 13/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class OrderConfirmationCell: UICollectionViewCell {
    @IBOutlet weak var uiImage: UIImageView!
    @IBOutlet weak var uiLabel: UILabel!
    @IBOutlet weak var uiView: UIView!
    
    var str:String!{
        didSet{
            uiView.collectionCellLayout()
//            uiLabel.backgroundColor = .red
//            uiLabel.layer.masksToBounds = true
        }
    }
    override class func awakeFromNib() {
        
    }
}
