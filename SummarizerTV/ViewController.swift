//
//  ViewController.swift
//  testTVOS
//
//  Created by Stephen Casella on 10/10/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var summaryCards = [String]()
    var titleArray = [String]()
    var linkArray = [String]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    /*let defaultSize = CGSizeMake(394, 590)
    let focusSize = CGSizeMake(494, 690)*/
    var movies = [Movie]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(NSUserDefaults(suiteName: "group.com.scasella.bookmark")?.objectForKey("bookmarkTest"))
    
        /*let test = NSUserDefaults(suiteName: "group.com.scasella.bookmark")!.objectForKey("summaryCardsGroup")
        print(test)*/
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    
       // downloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        downloadLinks()
    }
    
    
    
    func downloadLinks() {
      
        let url = NSURL(string: "https://api.import.io/store/data/2694348a-6889-469b-b1ce-cbda6c13cf15/_query?input/webpage/url=http%3A%2F%2Fnews.google.com&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69")!
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
                            
                            let summary = item["articleesctd_link"]
                        
                            self.linkArray.append(summary! as! String)
                        }
                        
                      
                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                                  self.downloadData()
                        })
                    }
                    
                    
                } catch {
                    
                }
            }
        }
        
        task.resume()
 
      
    }
    
    
    
   func downloadData() {
    for linkObj in linkArray {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: linkObj.stringByRemovingPercentEncoding!)!) { (data, response, error) -> Void in
            
            if let urlContent = data {
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                let websiteArray = webContent!.componentsSeparatedByString("<title>")
                
                if websiteArray.count > 1 {
                    
                    var weatherSummary = websiteArray[1].componentsSeparatedByString("</title>")
                    
                   // wasSuccessful = true
                    
                    
                        self.titleArray.append("\(weatherSummary[0])".stringByReplacingOccurrencesOfString("&#039;", withString: "'").stringByReplacingOccurrencesOfString("&#39;", withString: "'").stringByReplacingOccurrencesOfString("&#x27;", withString: "'"))
                        NSUserDefaults.standardUserDefaults().setObject(self.titleArray, forKey: "titleArray")
                }
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
                    NSUserDefaults.standardUserDefaults().setObject(self.summaryCards, forKey: "summaryCards")
                    
                    dispatch_sync(dispatch_get_main_queue()){
                        
                      /*  if loadingIndicator != nil {
                            loadingIndicator!.hidden = true
                            buttonToHideShow!.hidden = false
                        }*/
                        
                        self.collectionView.reloadData()
                        
                    }
                    
                }}
            
            } catch {
            
            print("not a dictionary")
            
                    } }
        
            
        
    }
    
    }
    
    task.resume()
    
    // })
    
}


}




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as? MovieCell {
           
       
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: "tapped:")
                tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
                cell.addGestureRecognizer(tap)
                
        }
            
            cell.largeText.selectable = true
            cell.largeText.panGestureRecognizer.allowedTouchTypes = [NSNumber(integer: UITouchType.Indirect.rawValue)]
            cell.largeText.preferredFocusedView
            
            cell.smallText.text = summaryCards[indexPath.row]
            cell.largeText.text = summaryCards[indexPath.row]
            
            cell.movieLbl.text = titleArray[indexPath.row]
            cell.largeLbl.text = titleArray[indexPath.row]
                       
            return cell
            
        } else {
            
            return MovieCell()
        }
    
    }
    
    
    
    func tapped(gesture: UITapGestureRecognizer) {
        if let _ = gesture.view as? MovieCell {
            print("load next view controller")
        }
    }

    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return summaryCards.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(650, 750 )
    }
    
    
   
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        if let prev = context.previouslyFocusedView as? MovieCell {
            
            prev.movieLbl.hidden = false
            prev.largeLbl.hidden = true
            prev.smallText.hidden = false
            prev.largeText.hidden = true
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                //prev.movieImg.frame.size = self.defaultSize
            })
           
            
        }
        
        if let next = context.nextFocusedView as? MovieCell {
        
            next.movieLbl.hidden = true
            next.largeLbl.hidden = false
            next.smallText.hidden = true
            next.largeText.hidden = false
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                //next.movieImg.frame.size = self.focusSize
            })
            
        }

    }
    
}

