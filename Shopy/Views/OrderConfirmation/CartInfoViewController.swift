//
//  CarInfoViewController.swift
//  Shopy
//
//  Created by mohamed youssef on 6/10/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit
import Stripe
import MarqueeLabel
import SDWebImage
import DropDown

protocol CardInfoViewControllerDelegate {
    func didClickDone(_ token: STPToken)
    func didClickCancel()
    func clearBag()
}

enum PaymentType : String{
    case cash = "Cash on Deliver"
    case stripe = "Visa"
}
class CartInfoViewController: UIViewController {
    
    //MARK: - IBOutlets
    //        @IBOutlet weak var doneButtonOutlet: UIButton!
    @IBOutlet weak var uiStackTextField: UIStackView!
    @IBOutlet weak var uiViewTextField: UIView!
    @IBOutlet weak var uiSubmitButton: UIButton!
    @IBOutlet weak var uiPaymentlabel: MarqueeLabel!
    @IBOutlet weak var uiName: UILabel!
    @IBOutlet weak var uiAddress: UILabel!
    @IBOutlet weak var uiPhone: UILabel!
    @IBOutlet weak var uiItemCount: UILabel!
    @IBOutlet weak var uiSubtotal: UILabel!
    @IBOutlet weak var uiDiscount: UILabel!
    @IBOutlet weak var uiTotal: UILabel!
    @IBOutlet weak var uiAddressDropDownView: UIView!
    
    let paymentCardTextField = STPPaymentCardTextField()
    private var viewModel = BagViewModel()
    var delegate: CardInfoViewControllerDelegate?
    var paymentMethod : PaymentType!
    var orderObject:OrderObject!
    var addressesDropDown:DropDown!
    var addressesArray : [String]!
    var allAddresses : [Address]!
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStackTextField.addArrangedSubview(paymentCardTextField)
        paymentCardTextField.delegate = self
        uiPaymentlabel.text! += paymentMethod.rawValue
        uiName.text! += MyUserDefaults.getValue(forKey: .username) as! String
        
        uiAddress.text! += "\(MyUserDefaults.getValue(forKey:.title) as! String), \(MyUserDefaults.getValue(forKey:.city) as! String), \(MyUserDefaults.getValue(forKey:.country) as! String)"
        uiPhone.text! += MyUserDefaults.getValue(forKey: .phone) as! String
        uiItemCount.text! = String(describing: orderObject.products.count)
        uiSubtotal.text = "$\(orderObject.subTotal)"
        
        uiDiscount.text = "$\(Double(round(100 * (orderObject.discount) )/100))"
        uiTotal.text = "$\(orderObject.subTotal - orderObject.discount)"
        
        self.addressesDropDown = DropDown()
        self.addressesDropDown.anchorView = self.uiAddressDropDownView
        self.addressesDropDown.direction = .bottom
        self.addressesDropDown.bottomOffset = CGPoint(x: 0, y:self.uiAddressDropDownView.plainView.bounds.height)
        
        addressesDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            let all = self.allAddresses[index]
            
            self.uiAddress.text = "Address : "
            self.uiAddress.text! += "\(String(describing: all.title!)), \(String(describing: all.city!)), \(String(describing: all.country!))"
            
        }
        
//        fetchAddresses()
    
    }
    
    func fetchAddresses() {
        let remote  = RemoteDataSource()
        
        remote.getCustomer(customerId: MyUserDefaults.getValue(forKey: .id) as! Int) { (customer) in
            guard let customer = customer else {return}
            
            self.allAddresses = customer.customer.addresses
            self.addressesArray = customer.customer.addresses.map({ $0.title! })
            self.addressesDropDown.dataSource = self.addressesArray
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAddresses()
        switch paymentMethod {
        case .cash:
            uiViewTextField.isHidden = true
            uiSubmitButton.alpha = 1
            uiSubmitButton.isEnabled = true
        case .stripe:
            uiViewTextField.isHidden = false
            uiSubmitButton.alpha = 0.5
            uiSubmitButton.isEnabled = false
        default:
            print("asd")
            uiStackTextField.isHidden = false
            uiStackTextField.alpha = 1
        }
    }
    
    @IBAction func uiSubmit(_ sender: Any) {
        
        switch paymentMethod {
        case .cash:
            self.viewModel.checkout(product: self.orderObject.products,status: .pending)
            viewModel.playSound(name: "Cash")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismissView()
            }
            delegate?.clearBag()
        case .stripe:
            processCard()
            self.viewModel.checkout(product: self.orderObject.products,status: .paid)
        default:
            self.viewModel.checkout(product: self.orderObject.products,status: .pending)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
//        delegate?.didClickCancel()
//        dismissView()
    }
    
    //MARK: - Helpers
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func processCard() {
        
        let cardParams = STPCardParams()
        cardParams.number = paymentCardTextField.cardNumber
        cardParams.expMonth = UInt(paymentCardTextField.expirationMonth)
        cardParams.expYear = UInt(paymentCardTextField.expirationYear)
        cardParams.cvc = paymentCardTextField.cvc
        
        STPAPIClient.shared.createToken(withCard: cardParams) { (token, error) in
            
            if error == nil {
                self.delegate?.didClickDone(token!)
                self.viewModel.playSound(name: "Cash")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dismissView()
                }
                self.delegate?.clearBag()
                //                    self.viewModel.checkout(product: self.bagProducts,status: .paid)
            } else {
                print("Error processing card token", error!.localizedDescription)
            }
        }
    }
    @IBAction func uiAddressesButton(_ sender: Any) {
        addressesDropDown.show()
    }
    
    
    @IBAction func uiClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



extension CartInfoViewController: STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        uiSubmitButton.isEnabled = textField.isValid
        uiSubmitButton.alpha = textField.isValid ? 1 : 0.5
    }
}

extension CartInfoViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        orderObject.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OrderConfirmationCell
        cell.str = ""
        cell.uiLabel.text = String(describing: (Int(orderObject.products[indexPath.row].count)))
//        cell.uiImage.image = UIImage(systemName: "pencil")
        
        if let image = orderObject.products[indexPath.row].image{
            cell.uiImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder"))
        }

        return cell
    }
    
}
