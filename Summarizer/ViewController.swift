//
//  ViewController.swift
//  Summarizer
//
//  Created by Stephen Casella on 9/23/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    @IBAction func seeFullArticle(sender: AnyObject) {
        urlForWebView = sender.restorationIdentifier as String!
        self.performSegueWithIdentifier("toWebView", sender: sender)
    }
    
  
    
    @IBOutlet var tableView: UITableView!
   
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryCards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : CustomCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
        
        cell.label.text = summaryCards[indexPath.row]
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.button.restorationIdentifier = urlArray[indexPath.row]
      
        return cell
    }
    
    
    func indexEnd(inputArray: [String]) -> Int {
        if inputArray.count == 0 {
            return 0
        } else {
            return inputArray.count - 1
        }
    }
    
    /* https://api.import.io/store/data/13523395-b0a2-4791-92e1-0c609717b53a/_query?input/url= [INSERT ENCODED URL] _user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69 */

}
