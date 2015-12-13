//
//  ViewController.swift
//  testTVOS
//
//  Created by Stephen Casella on 10/10/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit
import StoreKit

var unlocked = false

var currentNews = "https://api.import.io/store/data/a7ad8327-390c-4de5-947e-d1e17809186f/_query?input/webpage/url=http%3A%2F%2Fnews.google.com%2F%3Fsdm%3DTEXT%26authuser%3D0&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69"

var articleLink = ""
var titleArray = [String]()
var linkArray = [String]()
var summaryCards = [String]()
var providerArray = [String]()
var teaserArray = [String]()
//var summaryTitles = [String]()

//var focusVar = 0
var shouldSelectTable = false

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKRequestDelegate, SKPaymentTransactionObserver {
    
    var request: SKProductsRequest?
    var productID = Set(["summarizer_unlock_tv"])
    var productsArray: Array<SKProduct!> = []
    var product: SKProduct?
    
    var transactionInProgress = false
    var focusBack = false
    
    var segueToggle = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var headerBar: UIView!
    @IBOutlet weak var gatheringLabel: UILabel!
    @IBOutlet weak var activityLabel: UIActivityIndicatorView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var providerLabel: UILabel!

    
    
    let imgDefaultSize = CGSizeMake(594, 290)
    let imgFocusSize = CGSizeMake(644, 340)
    let fieldDefaultSize = CGSizeMake(577, 159)
    let fieldFocusSize = CGSizeMake(650, 195)
    let titleDefaultSize = CGSizeMake(577, 136)
    let titleFocusSize = CGSizeMake(650, 136)
    
    
    let newsDict = ["Trending": "https://api.import.io/store/data/a7ad8327-390c-4de5-947e-d1e17809186f/_query?input/webpage/url=http%3A%2F%2Fnews.google.com%2F%3Fsdm%3DTEXT%26authuser%3D0&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69", "US": "https://api.import.io/store/data/a8dc3aad-1453-4875-9662-6fd97a420a0d/_query?input/webpage/url=https%3A%2F%2Fnews.google.com%2Fnews%2Fsection%3Fpz%3D1%26topic%3Dn%26sdm%3DTEXT%26authuser%3D0&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69", "Business": "https://api.import.io/store/data/6eb3c0eb-35f6-4517-a679-b7159b72d954/_query?input/webpage/url=https%3A%2F%2Fnews.google.com%2Fnews%2Fsection%3Fpz%3D1%26topic%3Db%26sdm%3DTEXT%26authuser%3D0&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69", "Tech": "https://api.import.io/store/data/c6f47ce2-0a6e-4027-bd9d-1746512c40c4/_query?input/webpage/url=https%3A%2F%2Fnews.google.com%2Fnews%2Fsection%3Fpz%3D1%26topic%3Dtc%26sdm%3DTEXT%26authuser%3D0&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69", "Media":"https://api.import.io/store/data/3e3c1783-2f7f-49ac-9f87-696e6e760603/_query?input/webpage/url=https%3A%2F%2Fnews.google.com%2Fnews%2Fsection%3Fpz%3D1%26topic%3De%26sdm%3DTEXT%26authuser%3D0&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69","Health":"https://api.import.io/store/data/9123d445-0b1a-4732-a80b-e79e6525b073/_query?input/webpage/url=https%3A%2F%2Fnews.google.com%2Fnews%2Fsection%3Fpz%3D1%26topic%3Dm%26sdm%3DTEXT%26authuser%3D0&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69","Sports":"https://api.import.io/store/data/cf0d5716-cf73-4e8b-8bfa-48e4ca11e3a1/_query?input/webpage/url=https%3A%2F%2Fnews.google.com%2Fnews%2Fsection%3Fpz%3D1%26topic%3Ds%26sdm%3DTEXT%26authuser%3D0&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69","Science":"https://api.import.io/store/data/6f9a719e-ba33-466b-87ac-caaa624a325d/_query?input/webpage/url=https%3A%2F%2Fnews.google.com%2Fnews%2Fsection%3Fpz%3D1%26topic%3Dsnc%26sdm%3DTEXT%26authuser%3D0&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69"]
  
    @IBAction func segmentChanged(sender: UITapGestureRecognizer) {
        tableView.hidden = true
        gatheringLabel.text = "Gathering headlines..."
        switch segmentControl.selectedSegmentIndex {
        case 0: currentNews = newsDict["Trending"]!
        case 1: currentNews = newsDict["US"]!
        case 2: currentNews = newsDict["Business"]!
        case 3: currentNews = newsDict["Tech"]!
        case 4: currentNews = newsDict["Media"]!
        case 5: currentNews = newsDict["Sports"]!
        case 6: currentNews = newsDict["Health"]!
        case 7: currentNews = newsDict["Science"]!
        default: print("error")
    }
        downloadLinks(currentNews)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProductInfo() 
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    /*
        headerLabel.layer.shadowOpacity = 0.75
        headerLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        headerLabel.layer.shadowRadius = 5.0*/
        
        
        if shouldSelectTable != true {
       downloadLinks(currentNews)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func downloadLinks(url: String) {
        
        linkArray.removeAll()
        titleArray.removeAll()
        summaryCards.removeAll()
        //summaryTitles.removeAll()
        linkArray.removeAll()
        providerArray.removeAll()
        teaserArray.removeAll()
       
        /*let url = NSURL(string: "https://api.import.io/store/data/a7ad8327-390c-4de5-947e-d1e17809186f/_query?input/webpage/url=http%3A%2F%2Fnews.google.com%2F%3Fsdm%3DTEXT%26authuser%3D0&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69")! */
        let request = NSURLRequest(URL: NSURL(string: url)!)
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
                            
                            providerArray.append(provider! as! String)
                            
                            let teaser = item["teaser"]
                            
                            teaserArray.append(teaser! as! String)

                        }
                        
                        dispatch_sync(dispatch_get_main_queue()){

                        self.gatheringLabel.text = "Highlight a headline"
                        self.activityLabel.stopAnimating()
                        self.tableView.reloadData()
                        self.tableView.hidden = false
                           
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
            
            if cell.unlockLabel.hidden != false {
            
            
            focusBack = true
            backButton.hidden = false
            backButton.alpha = 0.1
            
            tableView.userInteractionEnabled = false
            segmentControl.userInteractionEnabled = false
            headerLabel.text = ""
            headerLabel.alpha = 0.0
            gatheringLabel.alpha = 0.0
            //activityLabel.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            activityLabel.startAnimating()
            activityLabel.hidden = false
            activityLabel.transform.ty = 275
            
            activityLabel.alpha = 0.0
            blurView.hidden = false
        
                
            UIView.animateWithDuration(1.00, animations: {
            self.headerBar.frame.size = CGSizeMake(1920, 1080)
            self.backButton.transform.ty = 747
            self.activityLabel.alpha = 1.0
            //self.headerLabel.frame.size = CGSizeMake(1584, 729)
           
                }, completion: {
                    (value: Bool) in
                    
                    downloadData(linkArray[titleArray.indexOf(cell.movieLbl.text!)!], textField: self.headerLabel, loadingInd: self.activityLabel, providerLabel: self.providerLabel)
                    articleLink = linkArray[titleArray.indexOf(cell.movieLbl.text!)!]
                    
                    UIView.animateWithDuration(0.75, animations: {
                    self.headerLabel.alpha = 1.0
                    self.blurView.alpha = 1.0
                    self.backButton.alpha = 1.0
                   
                })
                })
        
                self.setNeedsFocusUpdate()
                self.updateFocusIfNeeded()
            //performSegueWithIdentifier("toFullSegue", sender: self)
            
            //headerLabel.selectable = true
            //headerLabel.panGestureRecognizer.allowedTouchTypes = [NSNumber(integer: UITouchType.Indirect.rawValue)]
            //headerLabel.preferredFocusedView
            
            
            } else {
                showActions()
            }

        }
    }
    
    override weak var preferredFocusedView: UIView? {
        if focusBack == true {
            focusBack = false
            shouldSelectTable = true
            return backButton }
        else if shouldSelectTable == true {
            //shouldSelectTable = false
            return tableView
        } else {
            return segmentControl
        }
    }
    
    
    @IBAction func fullArticlePressed(sender: AnyObject) {
        performSegueWithIdentifier("toFullSegue", sender: self)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    
    
    func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        gatheringLabel.hidden = false 
        
        if let next = context.nextFocusedView as? MovieCell {
            
            UIView.animateWithDuration(2.5, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                self.segmentControl.alpha = 0.10
                
                }, completion:  nil)
        

            
           // gatheringLabel.hidden = true
            //activityLabel.hidden = true
            
            let views = UIView()
            views.backgroundColor = UIColor.clearColor()
            next.selectedBackgroundView = views
            
            let index = titleArray.indexOf(next.movieLbl.text!)
            
            if index! > 2 && unlocked == false {
    
                    gatheringLabel.hidden = true
                    next.movieLbl.hidden = true
                    next.unlockLabel.hidden = false
                    next.unlockAmountLabel.hidden = false
                    next.unlockImg.hidden = false
                    next.unlockImg.layer.cornerRadius = 24.0
                    
                } else {
                
                    gatheringLabel.text = teaserArray[index!]
            }
            
            
            next.movieLbl.frame.size = CGSizeMake(868, 212)
            //next.movieLbl.layer.transform = x
            next.movieLbl.font = UIFont.systemFontOfSize(CGFloat(48.0))
            
            
        } else {
             segmentControl.alpha = 1.0
        }
        
            if let prev = context.previouslyFocusedView as? MovieCell {
            prev.movieLbl.frame.size = CGSizeMake(668, 212)
            prev.movieLbl.font = UIFont.boldSystemFontOfSize(CGFloat(39.0))
            prev.movieLbl.hidden = false
            prev.unlockLabel.hidden = true
            prev.unlockImg.hidden = true 
            prev.unlockAmountLabel.hidden = true
            
    
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
    func getProductInfo()
    {
        if SKPaymentQueue.canMakePayments() {
            self.request = SKProductsRequest(productIdentifiers: self.productID)
           
            request!.delegate = self
            request!.start()
            
        }
    }
    
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
            
        }
        else {
            //print("There are no products.")
        }
    
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
        
    
    }
    
    
    
    func showActions() {
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "Unlock All Headlines", message: "All content will be permanently unlocked.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let buyAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) { (action) -> Void in
            let payment = SKPayment(product: self.productsArray[0] as SKProduct)
            SKPaymentQueue.defaultQueue().addPayment(payment)
            self.transactionInProgress = true
            }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        let restorePurchase = UIAlertAction(title: "Restore Purchase", style: UIAlertActionStyle.Default) { (action) -> Void in
            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
            self.transactionInProgress = true
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(restorePurchase)
        
        presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
     
    for transaction in transactions as! [SKPaymentTransaction] {
   
    switch transaction.transactionState {
    
    case SKPaymentTransactionState.Purchased:
    //print("Transaction completed successfully.")
    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    transactionInProgress = false
    unlocked = true
    NSUserDefaults.standardUserDefaults().setObject(unlocked, forKey: "unlocked")
    performSegueWithIdentifier("refreshSegue", sender: self)
        
    let alert = UIAlertController(title: "Thank You", message: "All headlines unlocked.", preferredStyle: UIAlertControllerStyle.Alert)
    presentViewController(alert, animated: true, completion: nil)
    
    case SKPaymentTransactionState.Restored:
        //print("Transaction completed successfully.")
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        transactionInProgress = false
        unlocked = true
        NSUserDefaults.standardUserDefaults().setObject(unlocked, forKey: "unlocked")
        performSegueWithIdentifier("refreshSegue", sender: self)
        
        let alert = UIAlertController(title: "Thank You", message: "Your purchase was restored.", preferredStyle: UIAlertControllerStyle.Alert)
        presentViewController(alert, animated: true, completion: nil)
        
    
    case SKPaymentTransactionState.Failed:
    //print("Transaction Failed");
    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    transactionInProgress = false
        
    let alert = UIAlertController(title: "Error", message: "Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
    presentViewController(alert, animated: true, completion: nil)
    
    default:
    print(transaction.transactionState.rawValue)
    
    }
    
        }
    }
    
}

