//
//  ArticleViewController.swift
//  Summarizer
//
//  Created by Stephen Casella on 9/26/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var addressField: UITextField!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var springView: SpringView!
    @IBOutlet var springViewParent: SpringView!
    
    
    
    @IBAction func homePressed(sender: AnyObject) {
   
        springViewParent.animate()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
        performSegueWithIdentifier("toCards", sender: self)
        
    }
    
    
    
    @IBAction func editingStart(sender: AnyObject) {
        webView.stopLoading()
    }

    
    
    @IBAction func goFieldPressed(sender: AnyObject) {
        goPressed(self)
        addressField.resignFirstResponder()
    }
    
    

    @IBAction func goPressed(sender: AnyObject) {
        var url: NSURL?
        
        if addressField.text?.rangeOfString("http://") != nil{
            url = NSURL (string: addressField.text!);
        } else {
            url = NSURL (string: "http://" + addressField.text!);
        }
       
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);

    }
    
    
    
    @IBAction func addPressed(sender: AnyObject) {
        addTitleAndSummary(addressField.text!, bookmarksSelected: false, tableRefresh: nil)
    }
    
    
    
    @IBAction func backPressed(sender: AnyObject) {
        if self.webView.canGoBack == true {
        self.webView.goBack()
    }
    }
    
    
    
    @IBAction func forwardPressed(sender: AnyObject) {
          if self.webView.canGoForward == true {
        self.webView.goBack()
    }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    let url = NSURL (string: "\(urlForWebView)");
    let requestObj = NSURLRequest(URL: url!);
    webView.loadRequest(requestObj);
    
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let currentURL : NSString = (webView.request?.URL!.absoluteString)!
        addressField.text = "\(currentURL)"
    }
    
  }