//
//  FirebaseCollectionReference.swift
//  Shopy
//
//  Created by mohamed youssef on 5/17/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Basket
}

func firebaseReference(_ collectionReference: FCollectionReference ) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
    
}
