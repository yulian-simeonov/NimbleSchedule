//
//  NSScheduleEmployee.swift
//  NimbleSchedule
//
//  Created by Apple Dev on 1/13/16.
//
//

import Foundation

class NSScheduleEmployee {
    
    var photoUrl : String!
    var email : String!
    var fullName : String!
    var id : String
    var periods : NSArray
    

    init?(){
    self.photoUrl = ""
    self.email = ""
    self.fullName = ""
    self.id = ""
    self.periods = NSArray()
    }
    
    func initFromDictionary (dict : NSDictionary) -> NSScheduleEmployee{
        let schedule = NSScheduleEmployee()
        schedule!.photoUrl = Utilities.getValidString(dict["photoUrl"] as? String, defaultString: "")
        schedule!.email = Utilities.getValidString(dict["email"] as? String, defaultString: "")
        schedule!.fullName = Utilities.getValidString(dict["fullName"] as? String, defaultString: "")
        schedule!.id = Utilities.getValidString(dict["id"] as? String, defaultString: "")
        schedule!.periods =  Utilities.ValidateArray(dict["periods"] as! NSArray)
        return schedule!
    }
    
}

