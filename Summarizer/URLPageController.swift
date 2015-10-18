//
//  URLPage.swift
//  Summarizer
//
//  Created by Stephen Casella on 9/26/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit

class URLPageController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var bookmarkArticleSelector: UISegmentedControl!
    @IBOutlet weak var buttonToCards: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var onboardingLabel: UILabel!
    @IBOutlet var homepageField: UITextField!
    @IBOutlet var timerLabel: SpringLabel!
    @IBOutlet weak var homepageSetView: UIView!
   
    
    
    @IBAction func selectorChanged(sender: AnyObject) {
        tableView.reloadData()
        
        func restoreDefaultTableView() {
            self.tableView.hidden = false
            self.onboardingLabel.hidden = true
        }
        
        if bookmarkArticleSelector.selectedSegmentIndex == 0 {
            
            urlTextField.placeholder = "Add favorite websites..."
            
            if bookmarkTitleArray.count == 0 {
                tableView.hidden = true
                onboardingLabel.text = "Add websites that post articles you like to read. Click the text box below."
                onboardingLabel.hidden = false
                
                } else {
                
                restoreDefaultTableView()
                
                }
            
            } else {
            
            urlTextField.placeholder = "Paste article URL..."
            
            if titleArray.count == 0 {
                tableView.hidden = true
                onboardingLabel.text = "Visit your favorite websites to add articles to summarize."
                onboardingLabel.hidden = false
            
                } else {
                
                restoreDefaultTableView()
            }
      }
    }
    
   
    
    @IBAction func addURL(sender: AnyObject) {
        var url = ""
        
        if urlTextField.text?.rangeOfString("http://") != nil{
            url = urlTextField.text!
        } else {
            url = "http://" + urlTextField.text!
        }
        
        
        if bookmarkArticleSelector.selectedSegmentIndex == 0 {
            
            addTitleAndSummary(url, bookmarksSelected: true, tableRefresh: self.tableView, loadingIndicator: nil, buttonToHideShow: nil)
            
            
            timerLabel.animateToNext() {
                self.tableView.reloadData()
            }
            
            
        } else {
            
            buttonToCards.hidden = true
            loadingIndicator.hidden = false
            
            addTitleAndSummary(url, bookmarksSelected: false, tableRefresh: self.tableView, loadingIndicator: loadingIndicator, buttonToHideShow: buttonToCards)
        
        }
        
        onboardingLabel.hidden = true
        tableView.hidden = false
        
        urlTextField.text = ""
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
        
        if showHomepageView == true {
        
        homepageSetView.hidden = false 
        homepageField.text = "\(homepage)"
            
        } else {
            
            homepageSetView.hidden = true 
        }
        
        if bookmarkArray.count == 0 {
            tableView.hidden = true
            onboardingLabel.hidden = false
        }
       
        }
    
    
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if bookmarkArticleSelector.selectedSegmentIndex == 0 {
        urlForWebView = bookmarkArray[indexPath.row]
            
        } else {
            
        urlForWebView = urlArray[indexPath.row]
       
        }
        
        performSegueWithIdentifier("toWebView", sender: self)
    }
    
    
    
   /* override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    } */
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if bookmarkArticleSelector.selectedSegmentIndex == 0 {
           return  bookmarkTitleArray.count
        } else {
        return titleArray.count
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        if bookmarkArticleSelector.selectedSegmentIndex == 0 {
            cell.textLabel?.text = bookmarkTitleArray[indexPath.row]
            cell.textLabel?.font = UIFont.systemFontOfSize(15.0)
            return cell
            
        } else {
        
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(13.0)
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

