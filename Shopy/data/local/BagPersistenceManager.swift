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
        do {
            let bagProducts = try context.fetch(BagProduct.fetchRequest()) as! [BagProduct]
            return bagProducts
        } catch  { return nil }
        
    }
    
    
    func isBagProduct(productID :Int )->Bool{
        guard let favourites = self.retrievebagProducts() else { return false}
        for fav in favourites {
            if fav.value(forKey: "id") as! Int64 == Int64(productID) {return true }
        }
        return false
        
    }
    
    func addToBagProducts(bagProduct  : ProductClass , count : Int = 1){
        let storedBagProduct = BagProduct(context: self.context)
        storedBagProduct.id  = Int64(bagProduct.id)
        storedBagProduct.count = Int64(count)
        storedBagProduct.image = bagProduct.images[0].src
        storedBagProduct.title = bagProduct.title
        storedBagProduct.price = bagProduct.variants[0].price
        storedBagProduct.variantId = Int64(bagProduct.variants[0].id)

        storedBagProduct.availableCount = Int64(bagProduct.variants[0].inventoryQuantity)
        try?self.context.save()
        print("added successfully")
    }
    
    
    func updateCount(productID :Int , count : Int){
        guard let bagProducts = self.retrievebagProducts() else {return}
        for bag in bagProducts {
            if bag.value(forKey: "id") as! Int64 == Int64(productID) {
                bag.count = Int64(count)
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
