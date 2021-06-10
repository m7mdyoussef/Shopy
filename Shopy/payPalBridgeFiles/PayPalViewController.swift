//
//  PayPalViewController.swift
//  Shopy
//
//  Created by mohamed youssef on 6/9/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import Stripe
import JGProgressHUD

struct pay {
    var title = "shoes"
    var price = 50
    var id = 1
    init(title: String , price: Int , id: Int) {
        self.title = title
        self.price = price
        self.id = id
    }
}

class PayPalViewController: UIViewController {

    var paymentVC: PayPalPaymentViewController?
    let allItems = [pay(title: "jdhk", price: 50, id: 1),pay(title: "jddhg", price: 150, id: 2)]
    var purchasedItemId = [Int]()

    var totalPrice = 0
    let hud = JGProgressHUD(style: .dark)

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func checkOut(_ sender: Any) {
        
     // show action sheet
        showPaymentOptins()
    }
    
    private func finishPayment(token: STPToken){
        
        var itemsToBuy : [PayPalItem] = []
        self.totalPrice = 0
        for item in allItems {
            self.totalPrice += item.price
            purchasedItemId.append(item.id)
            
        }
        self.totalPrice = self.totalPrice * 100
        
        StripeClient.sharedClient.createAndConfirmPayment(token, amount: totalPrice) { (error) in
            
            if error == nil {
                //self.emptyTheBasket()
               // self.addItemsToPurchaseHistory(self.purchasedItemIds)
                self.showNotification(text: "Payment Successful", isError: false)
            } else {
                self.showNotification(text: error!.localizedDescription, isError: true)
                print("error gegdgjgdjjhgejgfjhghrgjdhegejgfjegdjhgejfgjdhgjf ", error!.localizedDescription)
            }
        }
        
 
    }
    
    private func showNotification(text: String, isError: Bool) {
        
        if isError {
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        } else {
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        
        self.hud.textLabel.text = text
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    
    private func showPaymentOptins() {
        
        let alertController = UIAlertController(title: "Payment Options", message: "Choose prefered payment option", preferredStyle: .actionSheet)
        
        let cardAction = UIAlertAction(title: "Pay with Card", style: .default) { (action) in
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "cardInfoVC") as! CarInfoViewController
            
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cardAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


extension PayPalViewController: PayPalPaymentDelegate {
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("payment cancelled")
        paymentVC!.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        
        
        paymentVC!.dismiss(animated: true)
    }
    
    
}

extension PayPalViewController: CardInfoViewControllerDelegate {
    func didClickDone(_ token: STPToken) {
        print("we have a token ", token)
        finishPayment(token: token)
    }
    
    func didClickCancel() {
        print("user canceled the payment")
        showNotification(text: "you canceled the payment", isError: true)
    }
    
    
}
