//
//  NSScheduleUser.swift
//  NimbleSchedule
//
//  Created by Apple Dev on 1/13/16.
//
//

import Foundation

class NSScheduleUser {

    var startAt : String!
    var endAt : String!
    var shifts : NSArray!
    var weekdays : NSMutableArray!
    var filteredShifts : NSMutableArray!
    
    func initWithDictionary (scheduleDict : NSDictionary) -> NSScheduleUser{
    let schedule = NSScheduleUser()
        schedule!.startAt = Utilities.getValidString(scheduleDict["startAt"] as? String, defaultString: "")
        schedule!.endAt = Utilities.getValidString(scheduleDict["endAt"] as? String, defaultString: "")
        schedule!.shifts = Utilities.ValidateArray((scheduleDict["shifts"] as? NSArray)!)
     
        return schedule!
        
    }
    
    func getWeekDays(user : NSScheduleUser , week : NSInteger){
    let days = Utilities.daysInWeek(week, date: Utilities.dateFromString(Utilities.removeThumbnailSufix(user.startAt, removeCount: -1), isShortForm: true)!) as! NSMutableArray
        user.weekdays = days
    }
    
    init?(){
    self.startAt = ""
    self.endAt = ""
    self.shifts = NSArray()
    self.weekdays = NSMutableArray()
    self.filteredShifts = NSMutableArray()
    }
    
    func convertToDictionary() -> NSDictionary {
    let dict = NSMutableDictionary()
        
        dict.setValue(self.startAt, forKey: "startAt")
        dict.setValue(self.endAt, forKey: "endAt")
        dict.setValue(self.shifts, forKey: "shifts")
        dict.setValue(self.weekdays, forKey: "weekdays")
        return dict
        
    }
    
    func filterShifts (user : NSScheduleUser){
    //go through all days
        user.weekdays.enumerateObjectsUsingBlock { (a : AnyObject, i : Int, u : UnsafeMutablePointer<ObjCBool>) -> Void in
            //get day
            let currentDate = user.weekdays.objectAtIndex(i) as! NSDate
            
            //create array of shifts for that day
            let shiftsArray = NSMutableArray()
            //go through the shifts and compare dates
            user.shifts.enumerateObjectsUsingBlock({ (a : AnyObject,i : Int,u : UnsafeMutablePointer<ObjCBool>) -> Void in
                var shift = NSSchedulePeriod()
                shift = shift?.initFromDictionary(user.shifts.objectAtIndex(i) as! NSDictionary)
                //compare dates and see if the shift is in the date of week
                if (Utilities.filterDateForWeek(currentDate, dateToFilter: Utilities.dateFromStringHours(Utilities.removeThumbnailSufix((shift?.startAt)!, removeCount: -1), format: genericTimeFormat)) == true){
                    shiftsArray.addObject(shift!)
                }
            })
            user.filteredShifts.addObject(shiftsArray)
        
        }
    }
    
}