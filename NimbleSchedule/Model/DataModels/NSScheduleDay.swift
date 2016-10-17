//
//  NSScheduleDay.swift
//  NimbleSchedule
//
//  Created by Apple Dev on 1/13/16.
//
//

import Foundation
class NSScheduleDay {
    
    var startAt : String
    var employees : NSArray
    var openShifts: NSArray
   
    
    class func initWithDictionary(scheduleDic: NSDictionary) -> NSScheduleDay? {
        let schedule = NSScheduleDay()
        
        
        return schedule
    }
    
    func convertToDictionary() -> NSDictionary {
        let dict = NSMutableDictionary()
        
        dict.setValue(self.startAt, forKey: "startAt")
        dict.setValue(self.employees, forKey: "employees")
        dict.setValue(self.openShifts, forKey: "openShifts")
        
        return dict
    }
    
    
    init?() {
        self.startAt = ""
        self.employees = NSArray()
        self.openShifts = NSArray()
     
    }
    
    
    
    
}