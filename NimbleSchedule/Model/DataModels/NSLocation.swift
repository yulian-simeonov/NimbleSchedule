//
//  NSLocation.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 12/14/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class NSLocation {
    var ID: String
    var name: String
    var city: String
    var country: String
    var addressLine1: String
    var addressLine2: String
    var zipCode: String
    var phone: String
    var managerName: String
    var timeZone : String
    var inactive : Bool
    var primary : Bool
    var state : NSString
    
    // Hours Of Operation Data
    var hoursOperation: NSHoursOperation?

    class func initWithDictionary(locationDict: NSDictionary) -> NSLocation? {
        
        let location = NSLocation()
        if (locationDict["id"] == nil) {
            return nil
        }
        location!.ID = locationDict["id"] as! String
        location!.name = Utilities.getValidString(locationDict["name"] as? String, defaultString: "")
        location!.city = Utilities.getValidString(locationDict["city"] as? String, defaultString: "")
        location!.country = Utilities.getValidString(locationDict["country"] as? String, defaultString: "")
        location!.addressLine1 = Utilities.getValidString(locationDict["addressLine1"] as? String, defaultString: "")
        location!.addressLine2 = Utilities.getValidString(locationDict["addressLine2"] as? String, defaultString: "")
        location!.zipCode = Utilities.getValidString(locationDict["zipCode"] as? String, defaultString: "")
        location!.phone = Utilities.getValidString(locationDict["phone"] as? String, defaultString: "")
        location!.managerName = Utilities.getValidString(locationDict["managerName"] as? String, defaultString: "")
        location!.state = ((Utilities.getValidString(locationDict["state"] as? String, defaultString: "")) as? NSString)!
        location!.inactive = locationDict["inactive"] as! Bool
        location!.timeZone = locationDict["timeZone"] as! String
        location!.primary =  locationDict["primary"] as! Bool
      //  var managers = locationDict["managers"]
        //print(managers)
        /// location!.managers =   Utilities.ValidateArray(locationDict["managers"] as! NSArray)
        location!.hoursOperation = NSHoursOperation.initWithDictionary(locationDict["hours"] as? NSDictionary)
        
        return location
    }    

    
    init?() {      
        self.ID = "123"
        self.name = ""
        self.country = ""
        self.city = ""
        self.addressLine1 = ""
        self.addressLine2 = ""
        self.zipCode = ""
        self.phone = ""
        self.managerName = ""
        self.hoursOperation = NSHoursOperation()!
        self.timeZone = ""
        self.primary = false
        self.inactive = false
        self.state = ""
        if (self.ID.isEmpty) {
            return nil
        }
    }
}
