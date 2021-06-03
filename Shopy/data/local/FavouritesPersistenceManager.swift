//
//  FavouritesPersistenceManager.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 03/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation

import UIKit
import CoreData

let entityName="FavouriteProduct"




class FavouritesPersistenceManager{
    var context:NSManagedObjectContext!
    var entity:NSEntityDescription!
    
    static let shared = FavouritesPersistenceManager()
    
    private init(){
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        entity=NSEntityDescription.entity(forEntityName: entityName, in: context)  }
    
    
    func retrieveFavourites()->[FavouriteProduct]?{
        do {
            let favProducts = try context.fetch(FavouriteProduct.fetchRequest()) as! [FavouriteProduct]
            return favProducts
        } catch  {
            return nil
        }
         
    }
    
    
    
    
    func addToFavourites(favProduct  : ProductClass){
        let storedFavProduct = FavouriteProduct(context: self.context)
        storedFavProduct.id  = Int64(favProduct.id)
        storedFavProduct.image = favProduct.images[0].src
        storedFavProduct.title = favProduct.title
        storedFavProduct.price = favProduct.variants[0].price
        try?self.context.save()
        print("added successfully")
    }
    
    func removeLeague(productID :Int ){
//        let fetchRequest=NSFetchRequest<NSManagedObject>(entityName:entityName)
//        let storedFavourites=try?self.context.fetch(fetchRequest)
        guard let favourites = self.retrieveFavourites() else {
                   return
               }
        for fav in favourites {
            if fav.value(forKey: "id") as! Int64 == Int64(productID) {
                context.delete(fav)
                }
        }
        
        
    }
    func isFavourited(productID :Int )->Bool{
//        let fetchRequest=NSFetchRequest<NSManagedObject>(entityName:entityName)
//        let storedFavourites=try?self.context.fetch(fetchRequest)
        guard let favourites = self.retrieveFavourites() else {
                   return false
               }
        for fav in favourites {
            if fav.value(forKey: "id") as! Int64 == Int64(productID) {
              return true
                }
        }
        return false
        
    }
    
    
}
