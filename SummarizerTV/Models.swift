


import UIKit



func downloadData(linkObj: String, textField: UITextView) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        
        
        /* let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: linkObj.stringByRemovingPercentEncoding!)!) { (data, response, error) -> Void in
        
        if let urlContent = data {
        
        let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
        
        let websiteArray = webContent!.componentsSeparatedByString("<title>")
        
        if websiteArray.count > 1 {
        
        var weatherSummary = websiteArray[1].componentsSeparatedByString("</title>")
        
        // wasSuccessful = true
        
        
        self.titleArray.append("\(weatherSummary[0])".stringByReplacingOccurrencesOfString("&#039;", withString: "'").stringByReplacingOccurrencesOfString("&#39;", withString: "'").stringByReplacingOccurrencesOfString("&#x27;", withString: "'"))
        NSUserDefaults.standardUserDefaults().setObject(self.titleArray, forKey: "titleArray")
        }*/
        /*let encodedURL = linkObj.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!*/
        
        let mappedURLString = "https://api.import.io/store/data/13523395-b0a2-4791-92e1-0c609717b53a/_query?input/url=" + linkObj + "&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69"
        
        let mappedURL = NSURL(string: mappedURLString)
        
        let data = NSData(contentsOfURL: mappedURL!)
        
        if data != nil {
            
            do { let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                if let items = jsonData["results"] as? NSArray {
                    
                    for item in items {
                        
                        let summary = item["summarytext"]!
                        
                        summaryCards.append(summary as! String)
                        //NSUserDefaults.standardUserDefaults().setObject(self.summaryCards, forKey: "summaryCards")
                        
                        // self.summaryTitles.append(self.titleArray[self.linkArray.indexOf(linkObj)!])
                        
                        dispatch_sync(dispatch_get_main_queue()){
                            textField.text = summaryCards[0]
                            textField.textAlignment = NSTextAlignment.Justified
                            
                            /*  if loadingIndicator != nil {
                            loadingIndicator!.hidden = true
                            buttonToHideShow!.hidden = false
                            }*/
                            
                            //self.collectionView.reloadData()
                            
                        }
                        
                    }}
                
            } catch {
                
                print("not a dictionary")
                
            } }
        
        /*}
        
        task.resume()
        
        // })
        
        }*/
        
    })
    
}





