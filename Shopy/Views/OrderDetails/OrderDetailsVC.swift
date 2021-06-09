//
//  OrderDetailsVC.swift
//  Shopy
//
//  Created by Amin on 09/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class OrderDetailsVC: UIViewController {

    var order : Order!
    var viewModel:MeTapViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MeTapViewModel()
        
        viewModel.fetchOrderProducts(orderLineItems: order!.lineItems)
        
//        viewModel.orderProductsObservable?.asObservable().subscribe{ value in
//            print(value.element)
//        }
    }
    
}
