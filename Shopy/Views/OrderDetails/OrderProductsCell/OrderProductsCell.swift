//
//  OrderProductsCell.swift
//  Shopy
//
//  Created by Amin on 10/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import MarqueeLabel
import SDWebImage

class OrderProductsCell: UITableViewCell {

    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private weak var uiTitle: MarqueeLabel!
    @IBOutlet private weak var uiPrice: UILabel!
    @IBOutlet private weak var uiCount: UILabel!
    
    var product:Product!{
        willSet{
            uiImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            uiImage.sd_imageIndicator?.startAnimatingIndicator()
            uiImage.sd_setImage(with: URL(string: newValue.product.image.src), completed: { (image,error,cache,url) in
                self.uiImage.sd_imageIndicator?.stopAnimatingIndicator()
            })
            
            uiTitle.text = newValue.product.title
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
