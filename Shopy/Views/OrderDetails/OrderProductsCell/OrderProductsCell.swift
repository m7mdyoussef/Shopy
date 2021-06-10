//
//  OrderProductsCell.swift
//  Shopy
//
//  Created by Amin on 10/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import MarqueeLabel

class OrderProductsCell: UITableViewCell {

    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private weak var uiTitle: MarqueeLabel!
    @IBOutlet private weak var uiPrice: UILabel!
    @IBOutlet private weak var uiCount: UILabel!
    
    var product:Product!{
        willSet{
            uiImage.image = #imageLiteral(resourceName: "1")
            uiTitle.text = newValue.product.title
//            uiCount.text =
        }
    }
    
    var item:LineItems!{
        willSet{
            uiCount.text = "x\(newValue.quantity)"
            uiPrice.text = "\(newValue.price) LE"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
