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
    
    //Find and add title of webpage to titleArray
        var wasSuccessful = false
        
        let attemptedUrl = NSURL(string: urlTextField.text!)
        
        if let url = attemptedUrl {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    let websiteArray = webContent!.componentsSeparatedByString("<title>")
                    
                    if websiteArray.count > 1 {
                        
                        var weatherSummary = websiteArray[1].componentsSeparatedByString("</title>")
                        
                        wasSuccessful = true
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            titleArray.append("\(weatherSummary[0])")
                            NSUserDefaults.standardUserDefaults().setObject(titleArray, forKey: "titleArray")
                            self.tableView.reloadData()
                        })
                    }
                }
                
                if wasSuccessful == false {
                    
                }
            }
            
            task.resume()
            
        } else {
            
        }
        
        //Do urlArray and save everything. Clear text for next entry
        urlArray.append(urlTextField.text!)
         NSUserDefaults.standardUserDefaults().setObject(urlArray, forKey: "urlArray")
        urlTextField.text = ""
        urlTextField.resignFirstResponder()
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
           titleArray.removeAtIndex(indexPath.row)
           urlArray.removeAtIndex(indexPath.row)
           mappedURLs.removeAtIndex(indexPath.row)
           summaryCards.removeAtIndex(indexPath.row)
           NSUserDefaults.standardUserDefaults().setObject(titleArray, forKey: "titleArray")
           NSUserDefaults.standardUserDefaults().setObject(urlArray, forKey: "urlArray")
           NSUserDefaults.standardUserDefaults().setObject(mappedURLs, forKey: "mappedURLs")
           NSUserDefaults.standardUserDefaults().setObject(summaryCards, forKey: "summaryCards")

            tableView.reloadData()
        }
    }

}

