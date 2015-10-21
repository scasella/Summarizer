//
//  FullSummaryController.swift
//  Summarizer
//
//  Created by Stephen Casella on 10/21/15.
//  Copyright © 2015 Stephen Casella. All rights reserved.
//

import Foundation
import WatchKit

class FullSummaryController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        super.willActivate()

        table.setNumberOfRows(summaryCards.count, withRowType: "row")
        
        let row = table.rowControllerAtIndex(indexTapped) as! rowController
        
        let formattedSummary = summaryCards[indexTapped]
        
        let formattedTitle = titleArray[indexTapped]

        
        row.labelTitle.setText("\(formattedTitle)")
        row.labelSummary.setText("\(formattedSummary)")
        
    }
    
    
    
    
}