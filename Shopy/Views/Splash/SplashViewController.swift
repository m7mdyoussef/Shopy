//
//  SplashViewController.swift
//  Shopy
//
//  Created by SOHA on 6/14/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var splashImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        splashImage.loadGif(name: "splash")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            let vc = self.storyboard?.instantiateViewController(identifier: "rootTabController") as! UITabBarController
            
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
           // self.performSegue(withIdentifier: "splash", sender: nil)
            
        }
    }
    
    
    

    
}
