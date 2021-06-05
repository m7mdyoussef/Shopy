//
//  FavouritesPersistenceManager.swift
//  Shopy
//
//  Created by Mahmoud Elattar on 03/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import CoreData


class FavouritesPersistenceManager{
    
    var context:NSManagedObjectContext!
    static let shared = FavouritesPersistenceManager()
    
    private init(){
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                  }
    
    
    func retrieveFavourites()->[FavouriteProduct]?{
        do {
            let favProducts = try context.fetch(FavouriteProduct.fetchRequest()) as! [FavouriteProduct]
            return favProducts
        } catch  { return nil}
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
    
    func removeProduct(productID :Int ){
        guard let favourites = self.retrieveFavourites() else { return}
        for fav in favourites {
            if fav.value(forKey: "id") as! Int64 == Int64(productID) {context.delete(fav) }
        }
    }
    
    func isFavourited(productID :Int )->Bool{
        guard let favourites = self.retrieveFavourites() else {return false }
        for fav in favourites {
            if fav.value(forKey: "id") as! Int64 == Int64(productID) {return true }
        }
        return false
          }
 }
