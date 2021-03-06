//
//  BagPersistenceManager.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 05/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import CoreData

class BagPersistenceManager{
    
    var context:NSManagedObjectContext!
    static let shared = BagPersistenceManager()
    private init(){
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    func retrievebagProducts()->[BagProduct]?{
        let email = MyUserDefaults.getValue(forKey: .email) as! String
        var retrievedBagProducts = [BagProduct]()
        
        do {
           
            
            let bagProducts = try context.fetch(BagProduct.fetchRequest()) as! [BagProduct]
            bagProducts.forEach { product in
                if product.email == email {
                    retrievedBagProducts.append(product)
                }
            }
            return retrievedBagProducts
        } catch  { return nil }
        
    }
    func isBagProduct(productID :Int)->Bool{
        guard let favourites = self.retrievebagProducts() else { return false}
        for fav in favourites {
            
            if fav.value(forKey: "id") as! Int64 == Int64(productID){return true }
        }
        return false
        
    }
    func isSizeFound(productID :Int, size: String)->Bool{
    guard let favourites = self.retrievebagProducts() else { return false}
    for fav in favourites {
        var isFound = true
        let data = fav.value(forKey: "sizes")
        let arrSizes = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? [String]
        for index in arrSizes!{
            print(index)
            if index == size{
                isFound = true
            } else {
                isFound = false
            }
        }
        if (fav.value(forKey: "id") as! Int64 == Int64(productID) && isFound == true){return true }
    }
    return false
    
}
    func addToBagProducts(bagProduct : ProductClass , size: String, count : Int = 1){
        let storedBagProduct = BagProduct(context: self.context)
        storedBagProduct.id  = Int64(bagProduct.id)
        storedBagProduct.count = Int64(count)
        storedBagProduct.image = bagProduct.images[0].src
        storedBagProduct.title = bagProduct.title
        storedBagProduct.price = bagProduct.variants[0].price
        storedBagProduct.variantId = Int64(bagProduct.variants[0].id)
        storedBagProduct.sizeProduct = size
        let data = NSKeyedArchiver.archivedData(withRootObject: bagProduct.options[0].values)
        storedBagProduct.sizes = data
        storedBagProduct.availableCount = Int64(bagProduct.variants[0].inventoryQuantity)
        let email = MyUserDefaults.getValue(forKey: .email) as! String
        storedBagProduct.email = email
        try?self.context.save()
        print("added successfully")
    }
    func updateCount(productID :Int , count : Int,size:String){
        guard let bagProducts = self.retrievebagProducts() else {return}
        for bag in bagProducts {
            if bag.value(forKey: "id") as! Int64 == Int64(productID) {
                bag.count = Int64(count)
                bag.sizeProduct = size
                try?self.context.save()
            }
        }
    }
    func removeFromBag(productID :Int ){
        guard let bagProducts = self.retrievebagProducts() else {return}
        for bag in bagProducts {
            if bag.value(forKey: "id") as! Int64 == Int64(productID) {
                context.delete(bag)
            }
        }
        try?self.context.save()
    }
}
