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
            
            addTitleAndSummary(url, bookmarksSelected: true, tableRefresh: self.tableView)
        
            
        } else {
            addTitleAndSummary(url, bookmarksSelected: false, tableRefresh: self.tableView)
            
        }
        
        urlTextField.text = ""
        self.urlTextField.resignFirstResponder()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        }
    
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if bookmarkArticleSelector.selectedSegmentIndex == 0 {
        urlForWebView = bookmarkArray[indexPath.row]
        } else {
        urlForWebView = urlArray[indexPath.row]
        }
        
        performSegueWithIdentifier("toWebView", sender: self)
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

