//
//  NSMessage.Swift
//  NimbleSchedule
//
//  Created by Yosemite on 12/14/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import Foundation

class NSAvailability {
    var ID: String
    var title: String
    var startAt: NSDate
    var endAt: NSDate
    var howOften: String
    var notes: String
    
    class func initWithDictionary(positionDict: NSDictionary) -> NSAvailability? {

        let avail = NSAvailability()
        if (positionDict["id"] == nil) {
            return nil
        }
        avail!.ID = positionDict["id"] as! String
        
        return avail
    }
    
    init?() {
        self.ID = "123"
        self.title = ""
        self.startAt = NSDate()
        self.endAt = NSDate()
        self.howOften = ""
        self.notes = ""
        
        if (self.ID.isEmpty) {
            return nil
        }
    }
}