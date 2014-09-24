//
//  ViewController.swift
//  Pitspot
//
//  Created by Mateusz Zatorski on 23/09/2014.
//  Copyright (c) 2014 knowbody. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var webView: UIWebView!
    
    let url = "http://matt.local:3000"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}