//
//  URLPage.swift
//  Summarizer
//
//  Created by Stephen Casella on 9/26/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit
import WatchConnectivity

var trendTitleArray = [String]()
var trendLinkArray = [String]()


class URLPageController: UIViewController, UITableViewDelegate, UITableViewDataSource, WCSessionDelegate {
    
    var session: WCSession!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var bookmarkArticleSelector: UISegmentedControl!
    @IBOutlet weak var buttonToCards: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var onboardingLabel: UILabel!
    @IBOutlet weak var homepageField: UITextField!
    @IBOutlet weak var timerLabel: SpringLabel!
    @IBOutlet weak var homepageSetView: UIView!
   
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var springView: SpringView!
    
    
    @IBAction func selectorChanged(sender: AnyObject) {
        tableView.reloadData()
        urlTextField.hidden = false
        
        func restoreDefaultTableView() {
            self.tableView.hidden = false
            self.onboardingLabel.hidden = true
        }
        
        if bookmarkArticleSelector.selectedSegmentIndex == 1 {
            
            urlTextField.placeholder = "Add favorite websites..."
            
            if bookmarkTitleArray.count == 0 {
                tableView.hidden = true
                onboardingLabel.text = "Add websites that post articles you like."
                onboardingLabel.hidden = false
                
                } else {
                
                restoreDefaultTableView()
                
                }
            
            } else if bookmarkArticleSelector.selectedSegmentIndex == 2{
            
            urlTextField.placeholder = "Paste article URL..."
            
            if titleArray.count == 0 {
                tableView.hidden = true
                onboardingLabel.text = "Visit your favorite websites to add articles to summarize."
                onboardingLabel.hidden = false
            
            } else {
                
                restoreDefaultTableView()
            }
            
        } else {
            urlTextField.hidden = true
            onboardingLabel.hidden = true
            tableView.hidden = false 
            downloadTrending(tableView)
        }
    }
    
   
    
    @IBAction func addURL(sender: AnyObject) {
        
        if urlTextField.text != "" {
        
            var url = ""
        
        if urlTextField.text?.rangeOfString("http://") != nil{
            url = urlTextField.text!
        } else {
            url = "http://" + urlTextField.text!
        }
        
        
        if bookmarkArticleSelector.selectedSegmentIndex == 1 {
            
            addTitleAndSummary(url, bookmarksSelected: true, tableRefresh: self.tableView, loadingIndicator: nil, buttonToHideShow: nil)
            
            
            timerLabel.animateToNext() {
                self.tableView.reloadData()
            }
            
            
        } else if bookmarkArticleSelector.selectedSegmentIndex == 2{
            
            buttonToCards.hidden = true
            loadingIndicator.hidden = false
            
            addTitleAndSummary(url, bookmarksSelected: false, tableRefresh: self.tableView, loadingIndicator: loadingIndicator, buttonToHideShow: buttonToCards)
        
            
        } else {
            
        
        }
        
        onboardingLabel.hidden = true
        tableView.hidden = false
        
        urlTextField.text = ""
            
        }
            
        urlTextField.resignFirstResponder()
       
    }
    
    
    
    @IBAction func setHomepage(sender: AnyObject) {
     
        if homepageField.text != "" {
       
        if homepageField.text?.rangeOfString("http://") != nil{
            
            homepage = homepageField.text!
        
        } else {
           
            homepage = "http://" + homepageField.text!
        }
            NSUserDefaults.standardUserDefaults().setObject(homepage, forKey: "homepage")
       
        }
        
        homepageField.resignFirstResponder()
        homepageField.text = "\(homepage)"
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(WCSession.isSupported()) {
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
        } else {
            print("not avail") }
        
      
        
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 12.0
        
        homepageSetView.hidden = false
        homepageField.text = "\(homepage)"

        
        /*if showHomepageView == true {
        
        homepageSetView.hidden = false 
        homepageField.text = "\(homepage)"
            
        } else {
            
            homepageSetView.hidden = true 
        } */
        
        /*if bookmarkArray.count == 0 {
            tableView.hidden = true
            onboardingLabel.hidden = false
        }*/
       
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.whiteColor().CGColor
        tableView.layer.borderWidth = 0.5
        
       
        
        downloadTrending(tableView)
        
        
        }
    
    
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        
        if(WCSession.isSupported()) {
            if summaryCards.count != 0 {
                let dict = ["summary": summaryCards, "title": titleArray]
                session.transferUserInfo(dict)
            }
        }
    
    }
    
    
    
    @IBAction func closePressed(sender: AnyObject) {
        
        if(WCSession.isSupported()) {
            if summaryCards.count != 0 {
                let dict = ["summary": summaryCards, "title": titleArray]
                session.transferUserInfo(dict)
            }
        }
        
        springView.duration = 0.5
        springView.y = -1000
        springView.animateToNext() {
            
            if fromMainPage == true {
               self.performSegueWithIdentifier("toMain", sender: self)
            } else {
               self.performSegueWithIdentifier("toWebView", sender: self)
            }
        }
        

    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if bookmarkArticleSelector.selectedSegmentIndex == 1 {
        urlForWebView = bookmarkArray[indexPath.row]
        performSegueWithIdentifier("toWebView", sender: self)
            
        } else if bookmarkArticleSelector.selectedSegmentIndex == 2 {
            
        urlForWebView = urlArray[indexPath.row]
        performSegueWithIdentifier("toWebView", sender: self)
       
        } else {
            addTitleAndSummary(trendLinkArray[indexPath.row], bookmarksSelected: false , tableRefresh: nil, loadingIndicator: loadingIndicator, buttonToHideShow: buttonToCards)
        }
        
    }
    
    
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
    if fromMainPage == true {
        
        return UIStatusBarStyle.LightContent
        
    } else {
        
        return UIStatusBarStyle.Default
    }
    
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if bookmarkArticleSelector.selectedSegmentIndex == 1 {
           return  bookmarkTitleArray.count
        } else if bookmarkArticleSelector.selectedSegmentIndex == 2 {
        return titleArray.count
        } else {
            return trendTitleArray.count 
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        if bookmarkArticleSelector.selectedSegmentIndex == 1 {
            cell.textLabel?.text = bookmarkTitleArray[indexPath.row]
            cell.textLabel?.font = UIFont.systemFontOfSize(15.0)
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
            
        } else if bookmarkArticleSelector.selectedSegmentIndex == 2 {
        
            cell.textLabel?.text = titleArray[indexPath.row]
            cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        
        } else {
        
            cell.textLabel?.text = trendTitleArray[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.textLabel?.font = UIFont.systemFontOfSize(13.0)
            cell.textLabel?.textColor = UIColor.whiteColor()
            return cell
        
        }
       
    }
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if bookmarkArticleSelector.selectedSegmentIndex == 0 {
                bookmarkArray.removeAtIndex(indexPath.row)
                bookmarkTitleArray.removeAtIndex(indexPath.row)
                NSUserDefaults.standardUserDefaults().setObject(bookmarkArray, forKey: "bookmarkArray")
                NSUserDefaults.standardUserDefaults().setObject(bookmarkTitleArray, forKey: "bookmarkTitleArray")
            } else {
                
           urlArray.removeAtIndex(indexPath.row)
           titleArray.removeAtIndex(indexPath.row)
           summaryCards.removeAtIndex(indexPath.row)
           NSUserDefaults.standardUserDefaults().setObject(urlArray, forKey: "urlArray")
           NSUserDefaults.standardUserDefaults().setObject(titleArray, forKey: "titleArray")
           NSUserDefaults.standardUserDefaults().setObject(summaryCards, forKey: "summaryCards")
            }

           tableView.reloadData()
        }
    }

}

