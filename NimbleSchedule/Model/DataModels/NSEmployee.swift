//
//  NSEmployee.swift
//  NimbleSchedule
//
//  Created by Yosemite on 12/14/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class NSEmployee {
    var ID: String
    var name: String
    var avatarURL: NSURL
    var email: String
    var firstName: String
    var lastName: String
    var locationName: String
    var locationId: String
    
    // Contact Information
    var city: String
    var country: String
    var state: String
    var addressLine1: String
    var addressLine2: String
    var mobile: String
    var zipCode: String
    
    class func initWithDictionary(employeeDict: NSDictionary) -> NSEmployee? {
        let employee = NSEmployee()
        if (employeeDict["id"] == nil) {
            return nil
        }
        employee!.ID = employeeDict["id"] as! String
        employee!.name = Utilities.getValidString(employeeDict["name"] as? String, defaultString: "")
        employee!.firstName = Utilities.getValidString(employeeDict["firstName"] as? String, defaultString: "")
        employee!.lastName = Utilities.getValidString(employeeDict["lastName"] as? String, defaultString: "")
        employee!.email = Utilities.getValidString(employeeDict["email"] as? String, defaultString: "")        
        employee!.avatarURL = NSURL.init(string: Utilities.getValidString(employeeDict["photo"] as? String, defaultString: ""))!
        employee!.locationId = Utilities.getValidString(employeeDict["name"] as? String, defaultString: "")
        
        return employee
    }
    
    func updateWithContactInfo(contactInfoDict: NSDictionary) {
        self.city = Utilities.getValidString(contactInfoDict["city"] as? String, defaultString: "")
        self.state = Utilities.getValidString(contactInfoDict["state"] as? String, defaultString: "")
        self.zipCode = Utilities.getValidString(contactInfoDict["zipCode"] as? String, defaultString: "")
        self.mobile = Utilities.getValidString(contactInfoDict["mobile"] as? String, defaultString: "")
        self.country = Utilities.getValidString(contactInfoDict["country"] as? String, defaultString: "")
        self.addressLine1 = Utilities.getValidString(contactInfoDict["addressLine1"] as? String, defaultString: "")
        self.addressLine2 = Utilities.getValidString(contactInfoDict["addressLine2"] as? String, defaultString: "")
    }
    
    init?() {
        self.ID = "123"
        self.name = ""
        self.avatarURL = NSURL.init()
        self.name = ""
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.locationName = ""
        self.locationId = ""
        
        self.city = ""
        self.country = ""
        self.state = ""
        self.addressLine1 = ""
        self.addressLine2 = ""
        self.mobile = ""
        self.zipCode = ""
        
        if (self.ID.isEmpty) {
            return nil
        }
    }
}
