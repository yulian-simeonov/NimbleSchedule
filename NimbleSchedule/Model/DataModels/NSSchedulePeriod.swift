//
//  NSSchedulePeriod.swift
//  NimbleSchedule
//
//  Created by Apple Dev on 1/13/16.
//
//

import Foundation

class NSSchedulePeriod {
    var color : String!
    var employeeAvailabilityStatus : String!
    var employeeId : String!
    var employeeName : String!
    var endAt : String!
    var id : String!
    var isOpenShift : Bool = true
    var isPublished : Bool = true
    var isRepeated : Bool = true
    var locationId : String!
    var locationName : String!
    var payRate : Double!
    var positionName : String!
    var notes : String!
    var shiftsNumber : NSInteger = 0
    var startAt : String!
    var title : String!
    var totalHours : Double!
    var totalLaborCostWithoutBreaks : Double!
    var totalTimeWithoutBreaks : String!
    var employeePhoto : String!
    
    init?(){
        self.color = ""
        self.employeeAvailabilityStatus = ""
        self.employeeId = ""
        self.employeeName = ""
        self.endAt = ""
        self.id = ""
        self.isOpenShift = false
        self.isPublished = false
        self.isRepeated = false
        self.locationId = ""
        self.locationName = ""
        self.payRate = 0
        self.positionName = ""
        self.notes = ""
        self.shiftsNumber = 0
        self.startAt = ""
        self.title = ""
        self.totalHours = 0
        self.totalLaborCostWithoutBreaks = 0
        self.totalTimeWithoutBreaks = ""
        self.employeePhoto = ""
    }
    
    func initFromDictionary(dict : NSDictionary) -> NSSchedulePeriod {
        let schedule = NSSchedulePeriod()
        schedule!.color =  Utilities.getValidString(dict.valueForKey("color") as? String, defaultString: "")
        schedule!.employeeAvailabilityStatus =  Utilities.getValidString(dict.valueForKey("employeeAvailabilityStatus") as? String, defaultString: "")
        schedule!.employeeId = Utilities.getValidString(dict.valueForKey("employeeId") as? String, defaultString: "")
        schedule!.employeeName = Utilities.getValidString(dict.valueForKey("employeeName") as? String, defaultString: "")
        schedule!.endAt = Utilities.getValidString(dict.valueForKey("endAt") as? String, defaultString: "")
        schedule!.id = Utilities.getValidString(dict.valueForKey("id") as? String, defaultString: "")
        schedule!.isOpenShift = dict.valueForKey("isOpenShift") as! Bool
        schedule!.isPublished = dict.valueForKey("isPublished") as! Bool
        schedule!.isRepeated = dict.valueForKey("isRepeated") as! Bool
        schedule!.locationId = Utilities.getValidString(dict.valueForKey("locationId") as? String, defaultString: "")
        schedule!.locationName = Utilities.getValidString(dict.valueForKey("locationName") as? String, defaultString: "")
        //schedule!.payRate = dict.valueForKey("payRate") as! Double
        schedule!.positionName = Utilities.getValidString(dict.valueForKey("positionName") as? String, defaultString: "")
        schedule!.notes = Utilities.getValidString(dict.valueForKey("notes") as? String, defaultString: "")
        schedule!.shiftsNumber = dict.valueForKey("shiftsNumber") as! NSInteger
        schedule!.startAt = Utilities.getValidString(dict.valueForKey("startAt") as? String, defaultString: "")
        schedule!.title = Utilities.getValidString(dict.valueForKey("title") as? String, defaultString: "")
        //schedule!.totalHours = dict.valueForKey("totalHours") as! Double
       // schedule!.totalLaborCostWithoutBreaks = dict.valueForKey("totalLaborCostWithoutBreaks") as! Double
        schedule!.totalTimeWithoutBreaks = Utilities.getValidString(dict.valueForKey("totalTimeWithoutBreaks") as? String, defaultString: "")
        schedule!.employeePhoto = Utilities.getValidString(dict.valueForKey("employeePhoto") as? String, defaultString: "")
        
        return schedule!
    }
    
    
}

