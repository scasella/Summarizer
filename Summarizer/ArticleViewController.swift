//
//  ArticleViewController.swift
//  Summarizer
//
//  Created by Stephen Casella on 9/26/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!

 override func viewDidLoad() {
        super.viewDidLoad()
    let url = NSURL (string: "\(urlForWebView)");
    let requestObj = NSURLRequest(URL: url!);
    webView.loadRequest(requestObj);
    
    }


}