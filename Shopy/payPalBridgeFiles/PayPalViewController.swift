//
//  PayPalViewController.swift
//  Shopy
//
//  Created by mohamed youssef on 6/9/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

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
    var environment: String = PayPalEnvironmentNoNetwork {
        willSet (newEnvironment){
            if (newEnvironment != environment ) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPayPal()
    }


    @IBAction func checkOut(_ sender: Any) {
        
        payBtnpressed()
    }
    
    private func payBtnpressed(){
        
        var itemsToBuy : [PayPalItem] = []
        for item in allItems {
            let tempitem = PayPalItem(name: item.title, withQuantity: 1, withPrice: NSDecimalNumber(value: Int(item.price) ?? 20), withCurrency: "USD", withSku: nil)
            purchasedItemId.append(item.id)
            
            itemsToBuy.append(tempitem)
        }
        
        let subTotal = PayPalItem.totalPrice(forItems: itemsToBuy)
        
        //optional
        let shippingCost = NSDecimalNumber(string: "50.0")
        let tax = NSDecimalNumber(string: "5.0")

        let paymentdetails = PayPalPaymentDetails(subtotal: subTotal, withShipping: shippingCost, withTax: tax)
        let total = subTotal.adding(shippingCost).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Payment to Shopy", intent: .sale)
        payment.items = itemsToBuy
        payment.paymentDetails = paymentdetails
        
        
        if payment.processable {
            paymentVC = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)!
            
            present(paymentVC!, animated: true, completion: nil)
            
        }else{
            print("payment not processible")
        }
    }
    
    func setUpPayPal(){
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "iti"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .both
        
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
