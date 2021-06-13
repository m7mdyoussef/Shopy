//
//  OrderCell.swift
//  Shopy
//
//  Created by Amin on 08/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class OrderCell: UICollectionViewCell {

    @IBOutlet weak var uiContainerView: UIView!
    @IBOutlet weak var uiContentView: UIView!
    @IBOutlet private weak var uiBagImage: UIImageView!
    @IBOutlet private weak var uiOrderIdLabel: UILabel!
    @IBOutlet private weak var uiCountLabel: UILabel!
    @IBOutlet private weak var uiTotalLabel: UILabel!
    
    var orderData:Order?{
        
        didSet{
            guard let orderData = orderData else {return}
            uiOrderIdLabel.text! = "No. :\(String(orderData.orderNumber))"

            uiCountLabel.text = "\(orderData.lineItems.count) item/s"
            uiTotalLabel.text = "Total :$ \(orderData.totalPrice)"
            
//            self.uiContentView.layer.cornerRadius = 12.69
//            self.uiContentView.layer.masksToBounds = true
//            
//            let bezierPath = UIBezierPath.init(roundedRect: self.uiContainerView.bounds, cornerRadius: 12.69)
//            self.uiContainerView.layer.shadowPath = bezierPath.cgPath
//            self.uiContainerView.layer.masksToBounds = false
//            self.uiContainerView.layer.shadowColor = UIColor.black.cgColor
//            self.uiContainerView.layer.shadowRadius = 3.0
//            self.uiContainerView.layer.shadowOffset = CGSize.init(width: 0, height: 3)
//            self.uiContainerView.layer.shadowOpacity = 0.3
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
