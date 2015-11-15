//
//  ViewController.swift
//  testTVOS
//
//  Created by Stephen Casella on 10/10/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit

var articleLink = ""
var titleArray = [String]()
var linkArray = [String]()
var summaryCards = [String]()
//var summaryTitles = [String]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var providerArray = [String]()
    var teaserArray = [String]()
    
    var segueToggle = false
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var headerBar: UIView!
    @IBOutlet weak var fullArticleButton: UIButton!
    @IBOutlet weak var gatheringLabel: UILabel!
    @IBOutlet weak var activityLabel: UIActivityIndicatorView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var backButton: UIButton!
    
    let imgDefaultSize = CGSizeMake(594, 290)
    let imgFocusSize = CGSizeMake(644, 340)
    let fieldDefaultSize = CGSizeMake(577, 159)
    let fieldFocusSize = CGSizeMake(650, 195)
    let titleDefaultSize = CGSizeMake(577, 136)
    let titleFocusSize = CGSizeMake(650, 136)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      /*
        headerLabel.layer.shadowOpacity = 0.75
        headerLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        headerLabel.layer.shadowRadius = 5.0*/
        
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]

        segmentControl.setTitleTextAttributes(segAttributes as [NSObject : AnyObject], forState: UIControlState.Normal)

        linkArray.removeAll()
        titleArray.removeAll()
        summaryCards.removeAll()
        //summaryTitles.removeAll()
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
                        
                            linkArray.append(title! as! String)
                            
                            let titleName = item["title/_text"]
                            
                            titleArray.append(titleName! as! String)
                            
                            let provider = item["provider"]
                            
                            self.providerArray.append(provider! as! String)
                            
                            let teaser = item["teaser"]
                            
                            self.teaserArray.append(teaser! as! String)

                        }
                        
                        dispatch_sync(dispatch_get_main_queue()){

                        self.gatheringLabel.text = "Highlight a headline"
                        self.activityLabel.stopAnimating()
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
        if let cell = gesture.view as? MovieCell {
            
            tableView.userInteractionEnabled = false
            segmentControl.userInteractionEnabled = false
            headerLabel.text = ""
            headerLabel.alpha = 0.0
            gatheringLabel.alpha = 0.0
            //activityLabel.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            activityLabel.startAnimating()
            activityLabel.hidden = false
            activityLabel.transform.ty = 305
            activityLabel.alpha = 0.0
            fullArticleButton.alpha = 0.0
            backButton.alpha = 0.0
            blurView.hidden = false
            
            fullArticleButton.hidden = false
            backButton.hidden = false
            
            UIView.animateWithDuration(2.5, animations: {
            self.headerBar.frame.size = CGSizeMake(1920, 1080)
           
            self.activityLabel.alpha = 1.0
            self.backButton.preferredFocusedView
            //self.headerLabel.frame.size = CGSizeMake(1584, 729)
           
                }, completion: {
                    (value: Bool) in
                    UIView.animateWithDuration(1.5, animations: {
                    self.headerLabel.alpha = 1.0
                    self.blurView.alpha = 1.0
                    self.fullArticleButton.alpha = 1.0
                    self.backButton.alpha = 1.0
                    })
                })
        
            
            downloadData(linkArray[titleArray.indexOf(cell.movieLbl.text!)!], textField: headerLabel, loadingInd: activityLabel)
                
            articleLink = linkArray[titleArray.indexOf(cell.movieLbl.text!)!]
            //performSegueWithIdentifier("toFullSegue", sender: self)
            
            //headerLabel.selectable = true
            //headerLabel.panGestureRecognizer.allowedTouchTypes = [NSNumber(integer: UITouchType.Indirect.rawValue)]
            //headerLabel.preferredFocusedView
            
            
        }
    }
    

    
    
    @IBAction func fullArticlePressed(sender: AnyObject) {
        performSegueWithIdentifier("toFullSegue", sender: self)
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    
    
    func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        if let next = context.nextFocusedView as? MovieCell {
            
           // gatheringLabel.hidden = true
            activityLabel.hidden = true
            
            let views = UIView()
            views.backgroundColor = UIColor.clearColor()
            next.selectedBackgroundView = views
            
            let index = titleArray.indexOf(next.movieLbl.text!)
            
            gatheringLabel.text = teaserArray[index!]
            
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

