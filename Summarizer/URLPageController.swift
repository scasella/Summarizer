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
    
    @IBAction func addURL(sender: AnyObject) {
    
        addTitleAndUrl(urlTextField.text!)
        urlTextField.text = ""
        urlTextField.resignFirstResponder()
        self.tableView.reloadData()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        cell.textLabel?.text = titleArray[indexPath.row]
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
           urlArray.removeAtIndex(indexPath.row)
           titleArray.removeAtIndex(indexPath.row)
           mappedURLs.removeAtIndex(indexPath.row)
           summaryCards.removeAtIndex(indexPath.row)
           NSUserDefaults.standardUserDefaults().setObject(urlArray, forKey: "urlArray")
           NSUserDefaults.standardUserDefaults().setObject(titleArray, forKey: "titleArray")
           NSUserDefaults.standardUserDefaults().setObject(mappedURLs, forKey: "mappedURLs")
           NSUserDefaults.standardUserDefaults().setObject(summaryCards, forKey: "summaryCards")

            tableView.reloadData()
        }
    }

}

