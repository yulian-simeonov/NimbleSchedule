//
//  SharedDataManager.swift
//  NimbleSoftWare
//
//  Created by Yosemite on 10/9/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit
import CoreLocation

class SharedDataManager {
    var userId: String!
    var userName: String!
    var fullName: String!
    var password: String!
    var isLoggedIn: Bool!
    var employeeId: String!
    var defaultLocation : String!
    var defaultTimezone : String!
    var photo : String!
    var useRegionFiltering : Bool
    var timeZone : String!
    var offset : NSInteger
    var hasDepartments : Bool
    var weekStartDay : NSInteger
    
    var rootVC: RootViewController!
    var accessToken: String!
    
    var hours : NSHoursOperation!
    
    // LanguageCode - 0:English, 1:France
    var langCode: ELangCode
    {
        didSet {
            let userDefaults = NSUserDefaults.standardUserDefaults()
//            userDefaults.setObject(langCode.rawValue, forKey: "LanguageCode")
            userDefaults.synchronize()
        }
    }
    
    let locationManager = CLLocationManager()
    
    // Storyboard
    var scheduleStoryboard: UIStoryboard!
    var welcomeStoryboard: UIStoryboard!
    
    //schedule
    var weekSchedule : NSScheduleWeek!
    var shouldGetUserInfo : Bool = true
    var segmentIndex : NSInteger = 0
    var daySchedule : NSScheduleDay!
    var userSchedule : NSScheduleUser!
    var chosenCalendarDate : String!
    var userScheduleView : String = "Day"
    var temporaryData : NSMutableArray!
    
    // UIViewController
    var scheduleVC: ScheduleViewController!
    
    class var sharedInstance: SharedDataManager {
        struct Static {
            static let instance: SharedDataManager = SharedDataManager()
        }
        return Static.instance
    }
    
    init () {
//        super.init()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        print(userDefaults.boolForKey("IsLoggedIn"))
        userId = userDefaults.stringForKey("UserId")
        userName = userDefaults.stringForKey("UserName")
        fullName = userDefaults.stringForKey("FullName")
        password = userDefaults.stringForKey("Password")
        isLoggedIn = userDefaults.boolForKey("IsLoggedIn")
        employeeId = userDefaults.stringForKey("EmployeeId")
        defaultLocation = userDefaults.stringForKey("DefaultLocation")
        defaultTimezone = userDefaults.stringForKey("DefaultTimeZone")
        photo = userDefaults.stringForKey("Photo")
        useRegionFiltering = userDefaults.boolForKey("UseRegionFiltering")
        timeZone = userDefaults.stringForKey("TimeZone")
        offset = userDefaults.integerForKey("Offset")
        hasDepartments = userDefaults.boolForKey("HasDepartments")
        weekStartDay = userDefaults.integerForKey("WeekStartDay")
        
        // Language Code
        langCode = ELangCode(rawValue: userDefaults.integerForKey("LanguageCode"))!
        
        daySchedule = NSScheduleDay()
        
        self.scheduleStoryboard = UIStoryboard.init(name: "Schedule", bundle: NSBundle.mainBundle())
        self.welcomeStoryboard = UIStoryboard.init(name: "Welcome", bundle: NSBundle.mainBundle())
    }
    
    func saveUserInfo() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults .setObject(userId, forKey: "UserId")
        userDefaults .setObject(userName, forKey: "UserName")
        userDefaults .setObject(fullName, forKey: "FullName")
        userDefaults .setObject(isLoggedIn, forKey: "IsLoggedIn")
        userDefaults.setObject(password, forKey: "Password")
        userDefaults.setObject(employeeId, forKey: "EmployeeId")
        userDefaults.setObject(defaultLocation, forKey: "DefaultLocation")
        userDefaults.setObject(defaultTimezone, forKey: "DefaultTimezone")
        userDefaults.setObject(photo, forKey: "Photo")
        userDefaults.setObject(useRegionFiltering, forKey: "UseRegionFiltering")
        userDefaults.setObject(timeZone, forKey: "TimeZone")
        userDefaults.setObject(offset, forKey: "Offset")
        userDefaults.setObject(hasDepartments, forKey: "HasDepartments")
        userDefaults.setObject(weekStartDay, forKey: "WeekStartDay")
        
        userDefaults .synchronize()
    }
    
    func removeUserInfo() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        userDefaults .synchronize()
        
        userId = ""
        userName = ""
        password = ""
        isLoggedIn = false
        employeeId = ""
        fullName = ""
        defaultTimezone = ""
        defaultLocation = ""
        photo = ""
        useRegionFiltering = true
        timeZone = ""
        offset = 0
        hasDepartments = true
        weekStartDay = 0
        
    }
}
