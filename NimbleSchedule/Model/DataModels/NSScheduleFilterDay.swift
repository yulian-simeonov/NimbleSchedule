//
//  NSScheduleFilterDay.swift
//  NimbleSchedule
//
//  Created by Apple Dev on 1/12/16.
//
//

import Foundation
import Foundation

class NSScheduleFilterDay {
    var startAt: String
    var locationId: String
    var positionId: String
    var employeeId: String
    
    class func initWithDictionary(scheduleDic: NSDictionary) -> NSScheduleFilterDay? {
        let schedule = NSScheduleFilterDay()
        
        schedule!.startAt = Utilities.getValidString(scheduleDic["startAt"] as? String, defaultString: "")
        schedule!.locationId = Utilities.getValidString(scheduleDic["locationId"] as? String, defaultString: "")
        schedule!.positionId = Utilities.getValidString(scheduleDic["positionId"] as? String, defaultString: "")
        schedule!.employeeId = Utilities.getValidString(scheduleDic["employeeId"] as? String, defaultString: "")
        
        return schedule
    }
    
    func convertToDictionary() -> NSDictionary {
        let dict = NSMutableDictionary()
        
        dict.setValue(self.startAt, forKey: "startAt")
        dict.setValue(self.locationId, forKey: "locationId")
        dict.setValue(self.positionId, forKey: "positionId")
        dict.setValue(self.employeeId, forKey: "employeeId")
        
        
        return dict
    }
    
    
    init?() {
        self.startAt = ""
        self.locationId = ""
        self.positionId = ""
        self.employeeId = ""
}
}
    