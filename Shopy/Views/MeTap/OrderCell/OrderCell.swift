//
//  OrderCell.swift
//  Shopy
//
//  Created by Amin on 08/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class OrderCell: UICollectionViewCell {

    @IBOutlet private weak var uiBagImage: UIImageView!
    @IBOutlet private weak var uiOrderIdLabel: UILabel!
    @IBOutlet private weak var uiCountLabel: UILabel!
    @IBOutlet private weak var uiTotalLabel: UILabel!
    
    var orderData:Order?{
        
        didSet{
            guard let orderData = orderData else {return}
//            uiOrderIdLabel.text = String(orderData.orderNumber)
//            uiCountLabel.text = "\(orderData.lineItems.count) item/s in the order"
            uiTotalLabel.text = "Total : \(orderData.totalPrice)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
