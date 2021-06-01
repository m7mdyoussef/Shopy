//
//  CategoryContract.swift
//  Shopy
//
//  Created by mohamed youssef on 5/30/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import RxSwift

protocol CategoryContract{
    func fetchData()
    var errorObservable: Observable<Bool> {get}
    var LoadingObservable: Observable<Bool> {get}
    
    var mainCatDataObservable:Observable<[CustomElement]> {get}
    var subCatDataObservable:Observable<Set<String>> {get}

}
