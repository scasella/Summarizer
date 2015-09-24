//
//  ViewController.swift
//  Summarizer
//
//  Created by Stephen Casella on 9/23/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import UIKit

 var tester = [String]()
var urlArray = [ "https://api.import.io/store/data/13523395-b0a2-4791-92e1-0c609717b53a/_query?input/url=http%3A%2F%2Fwww.engadget.com%2F2015%2F09%2F22%2Fwhite-house-says-broadband-is-a-core-utility%2F&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69","https://api.import.io/store/data/13523395-b0a2-4791-92e1-0c609717b53a/_query?input/url=http%3A%2F%2Fwww.businessinsider.com%2Fvinod-khosla-awkward-techcrunch-disrupt-interview-2015-9&_user=269d78c6-495d-43df-899d-47320fc07fe4&_apikey=269d78c6495d43df899d47320fc07fe4886fa6efe4d7561df8557e1696cb76a1fef8f22d1807eda04e3cf5335799c8a1920d4d62f0801e9f5ecdb4b5901f7f4f5fa653f59f1b71fe22582aea9acc9f69"]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet var tableView: UITableView!
   

    
    
    override func viewDidAppear(animated: Bool) {
        tester.append("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func setCards(summary: AnyObject) {
            tester.append(summary as! String)
            tableView.reloadData()
        }


        for i: String in urlArray {
        let url = NSURL(string: i)
        
        let data = NSData(contentsOfURL: url!)
            
            let error:NSError? = nil
        do { let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
    
            if let items = jsonData["results"] as? NSArray {
            
            for item in items {
                
                   let summary = item["summarytext"]!
                    setCards(summary!)
                }}
                } catch {
                    print("not a dictionary")
                }
    
    }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tester.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : CustomCell! = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomCell
        
        cell.label.text = tester[indexPath.row]
       
        return cell
    }
    



}

