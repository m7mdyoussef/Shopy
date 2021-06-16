//
//  OrderDetailsVC.swift
//  Shopy
//
//  Created by Amin on 09/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import RxSwift
import MarqueeLabel
class OrderDetailsVC: UIViewController {

    @IBOutlet weak var uiProductsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var uiProductsTableView: UITableView!
    @IBOutlet weak var uiOrderId: UILabel!
    @IBOutlet weak var uiOrderProductsCount: UILabel!
    @IBOutlet weak var uiCreatedAt: MarqueeLabel!
    @IBOutlet weak var uiTotalPrice: MarqueeLabel!
    @IBOutlet weak var uiDiscount: MarqueeLabel!

    @IBOutlet weak var uiFinancialState: MarqueeLabel!
    
    var order : Order!
    var viewModel:MeTapViewModel!
    var bag:DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MeTapViewModel()
        bag = DisposeBag()
        setupViews()

        uiOrderId.text! += String(order.id)
        
        var count = 0
        
        for i in order.lineItems{
            count += i.quantity
        }
        
        uiOrderProductsCount.text! += "(\(count))"
        
        if let formatted = viewModel.getFormattedDate(date: order.createdAt){
            uiCreatedAt.text! = formatted
        }else{
            uiCreatedAt.isHidden = true
        }
        uiDiscount.text! += order.totalDiscounts
        uiTotalPrice.text! += order.totalPrice
        uiFinancialState.text = order.financialStatus
    }
    
    func setupViews() {
        registerCell()
        setupProductsTableView()
    }
    func setupProductsTableView() {
        uiProductsTableView.rx.setDelegate(self).disposed(by: bag)
        viewModel.orderProductsObservable?.asObservable().bind(to: uiProductsTableView.rx.items(cellIdentifier: "orderProductsCell")){ [unowned self] row,item,cell in
            if let cell = (cell as? OrderProductsCell){
                cell.product = item
                cell.item = self.order.lineItems[row]
            }
        }.disposed(by: bag)
        
//        viewModel.orderProductsObservable?.drive(onNext: { [unowned self] (products) in
//            uiProductsTableView.reloadData()
//        }).disposed(by: bag)
        viewModel.fetchOrderProducts(orderLineItems: order!.lineItems)
    }
    func registerCell() {
        let cell = UINib(nibName: "OrderProductsCell", bundle: nil)
        uiProductsTableView.register(cell, forCellReuseIdentifier: "orderProductsCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        uiProductsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        uiProductsTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                self.uiProductsTableViewHeight.constant = newSize.height
            }
        }
    }
}

extension OrderDetailsVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
