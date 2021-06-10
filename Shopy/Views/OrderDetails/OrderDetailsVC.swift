//
//  OrderDetailsVC.swift
//  Shopy
//
//  Created by Amin on 09/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import RxSwift
class OrderDetailsVC: UIViewController {

    @IBOutlet weak var uiProductsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var uiProductsTableView: UITableView!
    var order : Order!
    var viewModel:MeTapViewModel!
    var bag:DisposeBag!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MeTapViewModel()
        bag = DisposeBag()
        registerCell()
        viewModel.orderProductsObservable?.asObservable().bind(to: uiProductsTableView.rx.items(cellIdentifier: "orderProductsCell")){
            row,item,cell in
            
            if let cell = (cell as? OrderProductsCell){
                cell.product = item
                cell.item = self.order.lineItems[row]
            }
            
            
        }.disposed(by: bag)

    }
    
    func registerCell() {
        let cell = UINib(nibName: "OrderProductsCell", bundle: nil)
        uiProductsTableView.register(cell, forCellReuseIdentifier: "orderProductsCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        uiProductsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        viewModel.orderProductsObservable?.drive(onNext: { [unowned self] (products) in
            uiProductsTableView.reloadData()
        }).disposed(by: bag)
        viewModel.fetchOrderProducts(orderLineItems: order!.lineItems)
    }
    override func viewWillDisappear(_ animated: Bool) {
        uiProductsTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // add observer on the table view in viewWillAppear
    // remove the observer in viewWillDissappear
    // turn table view isScrollable = false
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                self.uiProductsTableViewHeight.constant = newSize.height
            }
        }
    }
}

