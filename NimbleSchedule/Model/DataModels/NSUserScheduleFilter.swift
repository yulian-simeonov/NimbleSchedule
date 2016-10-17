//
//  NSUserScheduleFilter.swift
//  NimbleSchedule
//
//  Created by Apple Dev on 1/13/16.
//
//

import Foundation

class NSUserScheduleFilter {
    var scheduleViewType  : String!
    var startAt : String!
    
    
    class func initWithDictionary(filterDic : NSDictionary) -> NSUserScheduleFilter{
    let filter = NSUserScheduleFilter()
    
        filter!.startAt = Utilities.getValidString(filterDic["startAt"] as? String, defaultString: "")
        filter!.scheduleViewType = Utilities.getValidString(filterDic["scheduleViewType"] as? String, defaultString: "")
        
        return filter!
    }
    
    func convertToDictionary() -> NSDictionary {
    let dict = NSMutableDictionary()
        dict.setValue(self.startAt, forKey: "startAt")
        dict.setValue(self.scheduleViewType, forKey: "scheduleViewType")
        
        return dict
        
    }
    
    init?(){
    self.startAt = ""
    self.scheduleViewType = ""
    }
    
}