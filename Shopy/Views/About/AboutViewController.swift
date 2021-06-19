//
//  AboutViewController.swift
//  Shopy
//
//  Created by SOHA on 6/19/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

  //  var vc : WebViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
  
    
    
    @IBAction func aminLinkedIn(_ sender: Any) {
        viewContact(url: "www.linkedin.com/in/mahmoud-amin-03325a148")
        
    }
    
    @IBAction func aminGithub(_ sender: Any) {
        viewContact(url: "")
    }
    
    @IBAction func elattarLinkedIn(_ sender: Any) {
        viewContact(url: "")
    }
    
    @IBAction func elattarGithub(_ sender: Any) {
        viewContact(url: "")
    }
    
    @IBAction func mohamedLinkedIn(_ sender: Any) {
        viewContact(url: "www.linkedin.com/mwlite/in/youssef0111")
    }
    
    @IBAction func mohamedGithub(_ sender: Any) {
       
        viewContact(url: "github.com/m7mdyoussef")
    }
    
    
    @IBAction func sohaLinkedIn(_ sender: Any) {
        viewContact(url: "www.linkedin.com/in/soha-mohamed")
    }
    
    @IBAction func sohaGithub(_ sender: Any) {
        viewContact(url: "github.com/SohaMohamed98")
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func viewContact(url:String){
        let vc = storyboard?.instantiateViewController(identifier: "WebViewController") as! WebViewController
        vc.webURL = url
        self.present(vc, animated: true)
        
    }
    
}
