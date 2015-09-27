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

var mappedURLs = [String]()

var summaryCards = [String]()

var updatesStartAtIndex = 0

var urlForWebView = ""

func addTitleAndUrl(urlText: String) {
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
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        titleArray.append("\(weatherSummary[0])")
                        NSUserDefaults.standardUserDefaults().setObject(titleArray, forKey: "titleArray")
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
    urlArray.append(urlText)
    NSUserDefaults.standardUserDefaults().setObject(urlArray, forKey: "urlArray")
}