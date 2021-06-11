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
    
    @IBOutlet weak var tableViewCellBackground: UIView!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var availableCount: UILabel!
    
    var countNumber = 1
    var availableStoredCount = 0
    
    var bagProduct : BagProduct? {
        didSet{
            guard let price = bagProduct?.price else {return}

            guard let inventoryCount = bagProduct?.availableCount else {return}
            self.availableStoredCount = Int(inventoryCount)
            self.price.text = "\(price)"
            self.availableCount.text = "\(inventoryCount)"

            self.title.text = bagProduct?.title
            self.count.text = "\(bagProduct?.count ?? 1)"
            self.countNumber = Int(bagProduct!.count)
            self.bagImage.doenloadImage(url: bagProduct?.image ?? "")
        }
    }
    var deleteFromBagProducts:()->() = {}
    var updateSavedCount:(Int , Bool)->() = {_,_ in}
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableViewCellBackground.collectionCellLayout()
    }

    @IBAction func decreaseCount(_ sender: Any) {
        if countNumber == 1 {
            deleteFromBagProducts()
        }
        else{
            countNumber-=1
            self.count.text = "\(countNumber)"
            self.updateSavedCount(countNumber ,true)
        }
    }
    @IBAction func increaseCount(_ sender: Any) {
        
        if countNumber+1 <= availableStoredCount {
            countNumber+=1
            self.count.text = "\(countNumber)"
            self.updateSavedCount(countNumber,true)
        }else{
            self.updateSavedCount(countNumber,false)
        }
      
    }
}
