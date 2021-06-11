//
//  ListAddressesVCViewController.swift
//  Shopy
//
//  Created by Amin on 04/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController {
    
    @IBOutlet weak var uiTitle: UITextField!
    @IBOutlet weak var uiCity: UITextField!
    @IBOutlet weak var uiZip: UITextField!
    @IBOutlet weak var uiCountry: UITextField!
    
    @IBOutlet weak var uiSaveBtn: UIButton!
    
    
    var address:Address?
    var delegate:UIUPdateAddressList!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let address = address {
            uiZip.text = address.zip
            uiCity.text = address.city
            uiCountry.text = address.country
            uiTitle.text = address.title
        }
    }
    
    func setupView() {
        roundSaveBtn()
    }
    func roundSaveBtn() {
        uiSaveBtn.layer.cornerRadius = uiSaveBtn.layer.frame.height / 2
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if uiTitle.text?.isEmpty != true && uiCity.text?.isEmpty != true &&  uiZip.text?.isEmpty != true &&
            uiCountry.text?.isEmpty != true {
            delegate.receive(address: Address(title: uiTitle.text, city: uiCity.text, zip: uiZip.text, country: uiCountry.text))
            dismiss(animated: true, completion: nil)

        }else{
//            delegate.receive(address: nil)
            onFaildHud(text: "Please fill Address Details ")
        }
        
    }
    
}

