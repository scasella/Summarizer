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
    
    @IBOutlet var timerLabel: SpringLabel!
   
    @IBAction func selectorChanged(sender: AnyObject) {
        tableView.reloadData()
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
        
        urlTextField.text = ""
        self.urlTextField.resignFirstResponder()
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
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
            return cell
            
        } else {
        
        cell.textLabel?.text = titleArray[indexPath.row]
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

