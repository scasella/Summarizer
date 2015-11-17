//
//  FullArticleController.swift
//  Summarizer
//
//  Created by Stephen Casella on 10/26/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit

var summaryArray = [String]()

class FullArticleController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
    
        textView.selectable = true
        textView.panGestureRecognizer.allowedTouchTypes = [NSNumber(integer: UITouchType.Indirect.rawValue)]
        textView.preferredFocusedView
        
        titleLabel.text = titleArray[linkArray.indexOf(articleLink)!]
        
      //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            //  let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            //let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            //dispatch_async(backgroundQueue, {
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        showArticle(articleLink)
    }
   
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        table.alpha = 1.0
        backButton.alpha = 1.0

        
        if let prev = context.previouslyFocusedView as? FullArticleCell {
            prev.label.textColor = UIColor.whiteColor()
        
            
        }
            
        if let next = context.nextFocusedView as? FullArticleCell {
                next.label.textColor = UIColor.blackColor()
        }
        
        if let _ = context.nextFocusedView as? UITextView {
                UIView.animateWithDuration(4.0, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                  self.table.alpha = 0.1
                  self.backButton.alpha = 0.1
              }, completion:  nil)
            }
        }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        imageView.image = nil
        
        showArticle(linkArray[indexPath.row])
        titleLabel.text = titleArray[indexPath.row]
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? FullArticleCell {
            
            if indexPath.row > 2 && unlocked == false {
                
                return cell
            } else {

            
            cell.label.text = titleArray[indexPath.row]
        
            return cell
            
            }
         } else {
            
            FullArticleCell()
            
        }
        
        return FullArticleCell()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if unlocked == true {
        return titleArray.count
        } else {
            return 3
        }
    }
    
    
    
    func showArticle(urlParam: String) {
   
        let sourceText = urlParam.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let urlText = "http://embed.ly/docs/explore/extract?url=" + "\(sourceText)"
        
        //Format URL for API, call API, return summary to summaryArray
        let encodedURL = urlText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        
        let mappedURLString = "https://api.import.io/store/data/9efacc91-3ee9-4935-b016-1d531eb52b83/_query?input/webpage/url=" + encodedURL + "&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69"
        
        let mappedURL = NSURL(string: mappedURLString)
        
        if let data = NSData(contentsOfURL: mappedURL!) {
        
        do { let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            if let items = jsonData["results"] as? NSArray {
                
                for item in items {
                    
                    let text = item["text"]!
                    
                    self.textView.text = text as! String
                    self.textView.setContentOffset(CGPointZero, animated:true)
                    //NSUserDefaults.standardUserDefaults().setObject(tickerTable, forKey: "tickerTable")
                    
                    if item["image"]! != nil {
                        
                        let image = item["image"]!

                        if image != nil {
                            
                            if let url = NSURL(string: "\(image!)") {
                                if let data = NSData(contentsOfURL: url){
                                    
                                    self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                                    self.imageView.image = UIImage(data: data)
                                }
                            }
                        }
                        
                    } else if item["imagetwo"]! != nil {
                        
                        let image = item["imagetwo"]!
                        
                        if image != nil {
                            
                            if let url = NSURL(string: "\(image!)") {
                                if let data = NSData(contentsOfURL: url){
                                    
                                    self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                                    self.imageView.image = UIImage(data: data)
                                }
                            }
                        }
                        
                    } else if item["imagethree"]! != nil {
                        
                        let image = item["imagethree"]!
                        
                        if image != nil {
                            
                            if let url = NSURL(string: "\(image!)") {
                                if let data = NSData(contentsOfURL: url){
                                    
                                    self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                                    self.imageView.image = UIImage(data: data)
                                }
                            }
                        }
                    }
                    
                    providerLabel.text = "from \(providerArray[linkArray.indexOf(articleLink)!])"
                    //NSUserDefaults.standardUserDefaults().setObject(priceArray, forKey: "priceArray")
                    
                }
                
            }
            
        } catch {
            
            print("not a dictionary")
            
        }

    }
    
    }
    
    }
