//
//  ArticleViewController.swift
//  Summarizer
//
//  Created by Stephen Casella on 9/26/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit
import WatchConnectivity

class ArticleViewController: UIViewController, UIWebViewDelegate, WCSessionDelegate {
    
    var session: WCSession!
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var springView: SpringView!
    @IBOutlet weak var springViewParent: SpringView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
  
    
    
    @IBAction func homePressed(sender: AnyObject) {
       
        if(WCSession.isSupported()) {
            if summaryCards.count != 0 {
                let dict = ["summary": summaryCards, "title": titleArray]
                session.transferUserInfo(dict)
            }
        }
   
        springViewParent.animate()
      
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
        
        addButton.enabled = false
        loadingIndicator.hidden = false
        closeButton.hidden = true
        
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
        loadingIndicator.hidden = false
        closeButton.hidden = true
        addButton.enabled = false
        addTitleAndSummary(addressField.text!, bookmarksSelected: false, tableRefresh: nil, loadingIndicator: loadingIndicator, buttonToHideShow: closeButton)
    
    }
    
    
    
    @IBAction func backPressed(sender: AnyObject) {
    if self.webView.canGoBack == true {
        self.webView.goBack()
        
        }
 
    }

    
    
    @IBAction func forwardPressed(sender: AnyObject) {
          if self.webView.canGoForward == true {
        self.webView.goForward()
    }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if(WCSession.isSupported()) {
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
        } else {
            print("not avail") }
        
        let url = NSURL (string: "\(urlForWebView)");
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
        
            loadingIndicator.hidden = false
        closeButton.hidden = true
        addButton.enabled = false 
    
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        if(WCSession.isSupported()) {
            if summaryCards.count != 0 {
                let dict = ["summary": summaryCards, "title": titleArray]
                session.transferUserInfo(dict)
            }
        }
        
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        addButton.enabled = false
        loadingIndicator.hidden = false
        closeButton.hidden = true
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let currentURL : NSString = (webView.request?.URL!.absoluteString)!
        loadingIndicator.hidden = true
        addButton.enabled = true
        closeButton.hidden = false
        
        addressField.text = "\(currentURL)"
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toURLPage" {
            fromMainPage = false 
            showHomepageView = true
        }
    }
    
    
    
  }