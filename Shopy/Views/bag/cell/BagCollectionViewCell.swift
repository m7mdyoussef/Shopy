//
//  BagCollectionViewCell.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 05/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class BagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bagImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var countNumber = 1
    
    var bagProduct : BagProduct? {
        didSet{
            guard let price = bagProduct?.price else {return}
            self.price.text = "\(price)$"
            self.title.text = bagProduct?.title
            self.count.text = "\(bagProduct?.count ?? 1)"
            self.countNumber = Int(bagProduct!.count)
            self.bagImage.doenloadImage(url: bagProduct?.image ?? "")
        }
    }
    var deleteFromBagProducts:()->() = {}
    var updateSavedCount:(Int)->() = {_ in}
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func decreaseCount(_ sender: Any) {
        if countNumber == 1 {
            deleteFromBagProducts()
        }
        else{
            countNumber-=1
            self.count.text = "\(countNumber)"
            self.updateSavedCount(countNumber)
        }
    }
    @IBAction func increaseCount(_ sender: Any) {
        countNumber+=1
        self.count.text = "\(countNumber)"
        self.updateSavedCount(countNumber)
    }
}
