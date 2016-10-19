//
//  NSHoursOperation.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 12/24/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit


class NSHoursOperationDay {
    var startsTime: NSDate?
    var endsTime: NSDate?
    var closedOn: Bool
    
    init?() {
        self.startsTime = NSDate()
        self.endsTime = NSDate()
        self.closedOn = false
    }
}

class NSHoursOperation {
    
    var sameOpenTimeEveryday: Bool = false
    var sameCloseTimeEveryday: Bool = false
    
    var openTimeEveryDay: NSDate?
    var closeTimeEveryDay: NSDate?
    
    var monHours: NSHoursOperationDay
    var tueHours: NSHoursOperationDay
    var wedHours: NSHoursOperationDay
    var thuHours: NSHoursOperationDay
    var friHours: NSHoursOperationDay
    var satHours: NSHoursOperationDay
    var sunHours: NSHoursOperationDay
    
    class func initWithDictionary(hoursDict: NSDictionary?) -> NSHoursOperation? {
        
        if (hoursDict == nil) {
            return nil
        }
        let hoursOperation = NSHoursOperation()
        
        hoursOperation?.sameOpenTimeEveryday = (hoursDict!["sameOpenTimeEveryday"]?.boolValue)!
        hoursOperation?.sameCloseTimeEveryday = (hoursDict!["sameCloseTimeEveryday"]?.boolValue)!
        
        hoursOperation?.openTimeEveryDay = Utilities.dateFromString(hoursDict!["openTimeEveryday"] as? String, isShortForm: true)
        hoursOperation?.closeTimeEveryDay = Utilities.dateFromString(hoursDict!["closeTimeEveryday"] as? String, isShortForm: true)
        
        hoursOperation!.satHours.closedOn = (hoursDict!["closedSaturday"]?.boolValue)!
        hoursOperation!.friHours.closedOn = (hoursDict!["closedFriday"]?.boolValue)!
        hoursOperation!.thuHours.closedOn = (hoursDict!["closedThursday"]?.boolValue)!
        hoursOperation!.wedHours.closedOn = (hoursDict!["closedWednesday"]?.boolValue)!
        hoursOperation!.tueHours.closedOn = (hoursDict!["closedTuesday"]?.boolValue)!
        hoursOperation!.monHours.closedOn = (hoursDict!["closedMonday"]?.boolValue)!
        hoursOperation!.sunHours.closedOn = (hoursDict!["closedSunday"]?.boolValue)!
        
        hoursOperation!.satHours.endsTime = Utilities.dateFromString(hoursDict!["closeTimeSaturday"] as? String, isShortForm: true)
        hoursOperation!.friHours.endsTime = Utilities.dateFromString(hoursDict!["closeTimeFriday"] as? String, isShortForm: true)
        hoursOperation!.thuHours.endsTime = Utilities.dateFromString(hoursDict!["closeTimeThursday"] as? String, isShortForm: true)
        hoursOperation!.wedHours.endsTime = Utilities.dateFromString(hoursDict!["closeTimeWednesday"] as? String, isShortForm: true)
        hoursOperation!.tueHours.endsTime = Utilities.dateFromString(hoursDict!["closeTimeTuesday"] as? String, isShortForm: true)
        hoursOperation!.monHours.endsTime = Utilities.dateFromString(hoursDict!["closeTimeMonday"] as? String, isShortForm: true)
        hoursOperation!.sunHours.endsTime = Utilities.dateFromString(hoursDict!["closeTimeSunday"] as? String, isShortForm: true)
        
        hoursOperation!.satHours.startsTime = Utilities.dateFromString(hoursDict!["openTimeSaturday"] as? String, isShortForm: true)
        hoursOperation!.friHours.startsTime = Utilities.dateFromString(hoursDict!["openTimeFriday"] as? String, isShortForm: true)
        hoursOperation!.thuHours.startsTime = Utilities.dateFromString(hoursDict!["openTimeThursday"] as? String, isShortForm: true)
        hoursOperation!.wedHours.startsTime = Utilities.dateFromString(hoursDict!["openTimeWednesday"] as? String, isShortForm: true)
        hoursOperation!.tueHours.startsTime = Utilities.dateFromString(hoursDict!["openTimeTuesday"] as? String, isShortForm: true)
        hoursOperation!.monHours.startsTime = Utilities.dateFromString(hoursDict!["openTimeMonday"] as? String, isShortForm: true)
        hoursOperation!.sunHours.startsTime = Utilities.dateFromString(hoursDict!["openTimeSunday"] as? String, isShortForm: true)

        return hoursOperation
    }
    
    func convertToDictionary() -> NSDictionary {
        let dict = NSMutableDictionary()
        
        dict.setValue(self.sameOpenTimeEveryday, forKey: "sameOpenTimeEveryday")
        dict.setValue(self.sameCloseTimeEveryday, forKey: "sameCloseTimeEveryday")
        
        dict.setValue(self.openTimeEveryDay, forKey: "openTimeEveryday")
        dict.setValue(self.closeTimeEveryDay, forKey: "closeTimeEveryday")
        
        dict.setObject(Utilities.stringFromDate(self.sunHours.startsTime, isShortForm: true), forKey: "openTimeSunday")
        dict.setObject(Utilities.stringFromDate(self.monHours.startsTime, isShortForm: true), forKey: "openTimeMonday")
        dict.setObject(Utilities.stringFromDate(self.tueHours.startsTime, isShortForm: true), forKey: "openTimeTuesday")
        dict.setObject(Utilities.stringFromDate(self.wedHours.startsTime, isShortForm: true), forKey: "openTimeWednesday")
        dict.setObject(Utilities.stringFromDate(self.thuHours.startsTime, isShortForm: true), forKey: "openTimeThursday")
        dict.setObject(Utilities.stringFromDate(self.friHours.startsTime, isShortForm: true), forKey: "openTimeFriday")
        dict.setObject(Utilities.stringFromDate(self.satHours.startsTime, isShortForm: true), forKey: "openTimeSaturday")
        
        dict.setObject(Utilities.stringFromDate(self.sunHours.endsTime, isShortForm: true), forKey: "closeTimeSunday")
        dict.setObject(Utilities.stringFromDate(self.monHours.endsTime, isShortForm: true), forKey: "closeTimeMonday")
        dict.setObject(Utilities.stringFromDate(self.tueHours.endsTime, isShortForm: true), forKey: "closeTimeTuesday")
        dict.setObject(Utilities.stringFromDate(self.wedHours.endsTime, isShortForm: true), forKey: "closeTimeWednesday")
        dict.setObject(Utilities.stringFromDate(self.thuHours.endsTime, isShortForm: true), forKey: "closeTimeThursday")
        dict.setObject(Utilities.stringFromDate(self.friHours.endsTime, isShortForm: true), forKey: "closeTimeFriday")
        dict.setObject(Utilities.stringFromDate(self.satHours.endsTime, isShortForm: true), forKey: "closeTimeSaturday")
        
        dict.setObject((self.sunHours.closedOn), forKey: "closedSunday")
        dict.setObject((self.monHours.closedOn), forKey: "closedMonday")
        dict.setObject((self.tueHours.closedOn), forKey: "closedTuesday")
        dict.setObject((self.wedHours.closedOn), forKey: "closedWednesday")
        dict.setObject((self.thuHours.closedOn), forKey: "closedThursday")
        dict.setObject((self.friHours.closedOn), forKey: "closedFriday")
        dict.setObject((self.satHours.closedOn), forKey: "closedSaturday")
   
        
        return dict
    }
    
    func stringBoolValue(boolValue : Bool) -> String{
        let stringValue : String!
        if(boolValue == true){
            stringValue = "true"
        }
        else {
            stringValue = "false"
        }
        
        return stringValue
    }
    
    init?() {
        self.openTimeEveryDay=nil
        self.closeTimeEveryDay=nil
        self.monHours = NSHoursOperationDay()!
        self.tueHours = NSHoursOperationDay()!
        self.wedHours = NSHoursOperationDay()!
        self.thuHours = NSHoursOperationDay()!
        self.friHours = NSHoursOperationDay()!
        self.satHours = NSHoursOperationDay()!
        self.sunHours = NSHoursOperationDay()!
        
    }
}
