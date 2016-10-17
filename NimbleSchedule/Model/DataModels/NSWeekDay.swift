//
//  NSWeekDay.swift
//  NimbleSchedule
//
//  Created by Apple Dev on 1/18/16.
//
//

import Foundation

class NSWeekDay {
    var day: String!
    var shifts : NSMutableArray!
    var openShifts : NSMutableArray!
    
    func initWithDictionary(scheduleDic: NSDictionary) -> NSWeekDay? {
        let schedule = NSWeekDay()
        schedule?.day = scheduleDic.valueForKey("day") as! String
        if(scheduleDic.valueForKey("shifts") != nil){
        schedule?.shifts =  Utilities.ValidateMutableArray(scheduleDic.valueForKey("shifts") as! NSMutableArray)
            if(scheduleDic.valueForKey("openShifts") != nil){
            schedule?.openShifts =  Utilities.ValidateMutableArray(scheduleDic.valueForKey("openShifts") as! NSMutableArray)
            }
            else{
                schedule?.openShifts = NSMutableArray()
            }
        }
        return schedule
    }
    
    init?() {
        self.day = ""
        self.shifts = NSMutableArray()
        self.openShifts = NSMutableArray()
    }
    
    
}
