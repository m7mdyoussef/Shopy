//
//  BagCollectionViewCell.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 05/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import DropDown

class BagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bagImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var tableViewCellBackground: UIView!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var availableCount: UILabel!
    
    @IBOutlet weak var uiDropShowMenu: UIButton!
    @IBOutlet weak var uiMenuAnchorView: UIView!
    @IBOutlet weak var uiPlus: UIButton!
    @IBOutlet weak var uiMinus: UIButton!
    
    private var sizeSelectionMenu:DropDown!

    var countNumber = 1
    var availableStoredCount = 0
    
    var bagProduct : BagProduct? {
        didSet{
            guard let price = bagProduct?.price else {return}

            guard let inventoryCount = bagProduct?.availableCount else {return}
            self.availableStoredCount = Int(inventoryCount)
            self.price.text = "$ \(price)"
            self.availableCount.text = "\(inventoryCount)"

            self.title.text = bagProduct?.title
            self.count.text = "\(bagProduct?.count ?? 1)"
            self.countNumber = Int(bagProduct!.count)
            self.bagImage.doenloadImage(url: bagProduct?.image ?? "")
            
            guard let size = bagProduct?.sizeProduct else {return}
            uiDropShowMenu.setTitle(" \(size) ", for: .normal)
            
            //initialize dropList
            sizeSelectionMenu = DropDown()
            sizeSelectionMenu.anchorView = uiMenuAnchorView
            let data = bagProduct?.sizes
            guard let arrSizes = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? [String] else {return}
            
            sizeSelectionMenu.dataSource = arrSizes
            sizeSelectionMenu.direction = .bottom
            sizeSelectionMenu.bottomOffset = CGPoint(x: 0, y:uiMenuAnchorView.plainView.bounds.height)
            
            
            sizeSelectionMenu.selectionAction = { [unowned self] (index: Int, item: String) in
                self.uiDropShowMenu.setTitle(" \(item) ", for: .normal)

            }
        }
    }
    var deleteFromBagProducts:()->() = {}
    var updateSavedCount:(Int , Bool)->() = {_,_ in}
        
    @IBAction func uiShowMenue(_ sender: Any) {
        sizeSelectionMenu.show()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableViewCellBackground.collectionCellLayout()
//        uiPlus.roundCorners(corners: [.topRight,.bottomRight], radius: uiPlus.frame.height/2)
//        uiMinus.roundCorners(corners: [.topLeft,.bottomLeft], radius: uiMinus.frame.height/2)
        uiPlus.roundCorners(corners: [.topRight,.bottomRight], radius: 12)
        uiMinus.roundCorners(corners: [.topLeft,.bottomLeft], radius: 12)
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
