//
//  ViewController.swift
//  testTVOS
//
//  Created by Stephen Casella on 10/10/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var summaryCards = [String]()
    var summaryTitles = [String]()
    var titleArray = [String]()
    var linkArray = [String]()
    var providerArray = [String]()
    var teaserArray = [String]()
    
    var segueToggle = false
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let imgDefaultSize = CGSizeMake(594, 290)
    let imgFocusSize = CGSizeMake(644, 340)
    let fieldDefaultSize = CGSizeMake(577, 159)
    let fieldFocusSize = CGSizeMake(650, 195)
    let titleDefaultSize = CGSizeMake(577, 136)
    let titleFocusSize = CGSizeMake(650, 136)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]

        segmentControl.setTitleTextAttributes(segAttributes as [NSObject : AnyObject], forState: UIControlState.Normal)

        linkArray.removeAll()
        titleArray.removeAll()
        summaryCards.removeAll()
        summaryTitles.removeAll()
        titleArray.removeAll()
        linkArray.removeAll()
        providerArray.removeAll()
        teaserArray.removeAll()
        
       downloadLinks()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func downloadLinks() {
       
        let url = NSURL(string: "https://api.import.io/store/data/a7ad8327-390c-4de5-947e-d1e17809186f/_query?input/webpage/url=http%3A%2F%2Fnews.google.com%2F%3Fsdm%3DTEXT%26authuser%3D0&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69")!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if error != nil {
                print(error.debugDescription)
            } else {
                do { let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary
                   
                    if let items = dict!["results"] as? NSArray {
                      
                        for item in items {
                            
                            let title = item["title"]
                        
                            self.linkArray.append(title! as! String)
                            
                            let titleName = item["title/_text"]
                            
                            self.titleArray.append(titleName! as! String)
                            
                            let provider = item["provider"]
                            
                            self.providerArray.append(provider! as! String)
                            
                            let teaser = item["teaser"]
                            
                            self.teaserArray.append(teaser! as! String)

                        }
                        
                        dispatch_sync(dispatch_get_main_queue()){

                        
                        self.tableView.reloadData()
                           
                        }
                      
                      // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        
                      //  })
                    }
                    
                    
                } catch {
                    
                }
             // self.downloadData()
            }
        }
        
        task.resume()
    
    }
    
    
    
    func downloadData(linkObj: String) {
  
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
   
        
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
                    
                    self.summaryCards.append(summary as! String)
                    //NSUserDefaults.standardUserDefaults().setObject(self.summaryCards, forKey: "summaryCards")
                    
                    self.summaryTitles.append(self.titleArray[self.linkArray.indexOf(linkObj)!])
                    
                    //dispatch_sync(dispatch_get_main_queue()){
                        print(summaryCards)
                    
                      /*  if loadingIndicator != nil {
                            loadingIndicator!.hidden = true
                            buttonToHideShow!.hidden = false
                        }*/
                        
                        //self.collectionView.reloadData()
                        
                    //}
                    
                }}
            
            } catch {
            
            print("not a dictionary")
            
                    } }
        
            
        
    
    
    /*}
    
    task.resume()
    
    // })
    
}*/
//})

}




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as? MovieCell {
           
       
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: "tapped:")
                tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
                cell.addGestureRecognizer(tap)
                
        }
          
            cell.movieLbl.text = titleArray[indexPath.row]
                       
            return cell
            
        } else {
            
            return MovieCell()
        }
    
    }
    
    
    
    func tapped(gesture: UITapGestureRecognizer) {
        if let _ = gesture.view as? MovieCell {
           
        print("clickled")
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    
    func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
         if let next = context.nextFocusedView as? MovieCell {
            
            let views = UIView()
            
            views.backgroundColor = UIColor.clearColor()
         
            next.selectedBackgroundView = views
            
            next.movieLbl.frame.size = CGSizeMake(868, 212)
            //next.movieLbl.layer.transform = x
            next.movieLbl.font = UIFont.systemFontOfSize(CGFloat(48.0))
            
        }
        
          if let prev = context.previouslyFocusedView as? MovieCell {
            prev.movieLbl.frame.size = CGSizeMake(668, 212)
            prev.movieLbl.font = UIFont.systemFontOfSize(CGFloat(39.0))
        }
    }
    
    
    /*
   
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
       // segueToggle = false
        //collectionView.reloadData()
        
        if let prev = context.previouslyFocusedView as? MovieCell {
        
            
           UIView.animateWithDuration(0.5, animations: { () -> Void in
        
               /* prev.movieImg.frame.size = self.imgDefaultSize
                prev.movieImg.layer.shadowOpacity = 0.0
            
                 prev.smallText.frame.size = self.fieldDefaultSize   */
                prev.movieLbl.frame.size = self.titleDefaultSize
           })
           
            
        }
        
        if let next = context.nextFocusedView as? MovieCell {
           
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                next.movieLbl.frame.size = self.titleFocusSize

        /*  next.movieImg.frame.size = self.imgFocusSize
                       next.smallText.frame.size = self.fieldFocusSize
                
            next.movieImg.layer.shadowColor = UIColor.blackColor().CGColor
            next.movieImg.layer.shadowOffset = CGSize(width: 0.0, height: 8)
            next.movieImg.layer.shadowRadius = CGFloat(15.0)
            next.movieImg.layer.shadowOpacity = 0.50*/
            
          })
            
        }

    }
*/
}

