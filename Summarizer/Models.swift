//
//  Models.swift
//  Summarizer
//
//  Created by Stephen Casella on 9/26/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit

var urlArray = [String]()

var titleArray = [String]()

var bookmarkArray = [String]()

var bookmarkTitleArray = [String]()

var summaryCards = [String]()

var updatesStartAtIndex = 0

var urlForWebView = ""

func addTitleAndSummary(urlText: String, bookmarksSelected: Bool, tableRefresh: UITableView?) {
    
    if bookmarksSelected == false {
        
    urlArray.append(urlText)
    NSUserDefaults.standardUserDefaults().setObject(urlArray, forKey: "urlArray")
        
    } else {
        
        bookmarkArray.append(urlText)
        NSUserDefaults.standardUserDefaults().setObject(bookmarkArray, forKey: "bookmarkArray")
    }
    
    var wasSuccessful = false
    
    let attemptedUrl = NSURL(string: urlText)
    
    if let url = attemptedUrl {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data {
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                let websiteArray = webContent!.componentsSeparatedByString("<title>")
                
                if websiteArray.count > 1 {
                    
                    var weatherSummary = websiteArray[1].componentsSeparatedByString("</title>")
                    
                    wasSuccessful = true
                    
                    if bookmarksSelected == false {
                        titleArray.append("\(weatherSummary[0])".stringByReplacingOccurrencesOfString("&#039;", withString: "'").stringByReplacingOccurrencesOfString("&#39;", withString: "'"))
                        NSUserDefaults.standardUserDefaults().setObject(titleArray, forKey: "titleArray")
                        
                    } else {
                        
                        bookmarkTitleArray.append("\(weatherSummary[0])".stringByReplacingOccurrencesOfString("&#039;", withString: "'").stringByReplacingOccurrencesOfString("&#39;", withString: "'"))
                        NSUserDefaults.standardUserDefaults().setObject(bookmarkTitleArray, forKey: "bookmarkTitleArray")
                        if tableRefresh != nil {
                            tableRefresh!.reloadData() }
                        return
                        
                    }

                        
                        if tableRefresh != nil {
                            tableRefresh!.reloadData() }
                        
                    
                        //Format URL for API, call API, return summary to summaryArray
                        let encodedURL = urlText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
                        
                        let mappedURLString = "https://api.import.io/store/data/13523395-b0a2-4791-92e1-0c609717b53a/_query?input/url=" + encodedURL + "&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69"
                    
                        let mappedURL = NSURL(string: mappedURLString)
                        
                        let data = NSData(contentsOfURL: mappedURL!)
                        
                        do { let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        
                        if let items = jsonData["results"] as? NSArray {
                        
                        for item in items {
                        
                        let summary = item["summarytext"]!
                            
                         summaryCards.append(summary as! String)
                         NSUserDefaults.standardUserDefaults().setObject(summaryCards, forKey: "summaryCards")
                            
                        }}
                            
                        } catch {
                            
                        print("not a dictionary")
                        
                        }
                     dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if tableRefresh != nil {
                            tableRefresh!.reloadData() }
                     })
                }
            }
            
            if wasSuccessful == false {
                
            }
        }
        
        task.resume()
        
    } else {
        
    }

}
