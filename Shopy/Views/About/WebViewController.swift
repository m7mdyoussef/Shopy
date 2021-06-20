//
//  WebViewController.swift
//  Shopy
//
//  Created by SOHA on 6/19/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var webURL : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://\(webURL)")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
