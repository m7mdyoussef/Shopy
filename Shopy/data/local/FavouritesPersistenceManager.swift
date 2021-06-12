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
        let email = MyUserDefaults.getValue(forKey: .email) as! String
        var retrievedFavourites = [FavouriteProduct]()
        do {
            let favProducts = try context.fetch(FavouriteProduct.fetchRequest()) as! [FavouriteProduct]
            favProducts.forEach { product in
                if product.email == email {
                    retrievedFavourites.append(product)
                }
            }
            return retrievedFavourites

        } catch  { return nil}
         }

    
    
    func addToFavourites(favProduct  : ProductClass){
        let storedFavProduct = FavouriteProduct(context: self.context)
        storedFavProduct.id  = Int64(favProduct.id)
        storedFavProduct.image = favProduct.images[0].src
        storedFavProduct.title = favProduct.title
        storedFavProduct.price = favProduct.variants[0].price
        let email = MyUserDefaults.getValue(forKey: .email) as! String
        storedFavProduct.email = email
        try?self.context.save()
        print("added successfully")
    }
    
    func removeProduct(productID :Int ){
        guard let favourites = self.retrieveFavourites() else { return}
        for fav in favourites {
            if fav.value(forKey: "id") as! Int64 == Int64(productID) {context.delete(fav) }
        }
        // amin
        try?self.context.save()
    }
    
    func isFavourited(productID :Int )->Bool{
        guard let favourites = self.retrieveFavourites() else {return false }
        for fav in favourites {
            if fav.value(forKey: "id") as! Int64 == Int64(productID) {return true }
        }
        return false


          }
 }

