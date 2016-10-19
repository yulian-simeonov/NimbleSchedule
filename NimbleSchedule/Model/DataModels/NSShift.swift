//
//  NSShift.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/1/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class NSShift {
    var ID: String
    var employeeID: String
    var employeeName: String
    var locationName: String
    var positionName: String
    var departmentName: String
    var startAt: NSDate
    var endAt: NSDate
    var color: UIColor
    var title: String
    var notes: String
    var published: Bool
    
    init?() {
        self.ID = "123"
        self.employeeID = ""
        self.employeeName = ""
        self.locationName = ""
        self.positionName = ""
        self.departmentName = ""
        self.startAt = NSDate()
        self.endAt = NSDate()
        self.color = UIColor.whiteColor()
        self.title = ""
        self.notes = ""
        self.published = false
        
        if (self.ID.isEmpty) {
            return nil
        }
    }
}
