//
//  NSScheduleWeek.swift
//  NimbleSchedule
//
//  Created by Apple Dev on 1/12/16.
//
//

import Foundation

class NSScheduleWeek {
    var days: NSDictionary
    var employees: NSArray
    var openShifts: NSArray
    var weekdays : NSMutableArray

     func initWithDictionary(scheduleDic: NSDictionary) -> NSScheduleWeek? {
        let schedule = NSScheduleWeek()
        schedule?.days = scheduleDic.valueForKey("days") as! NSDictionary
        schedule?.employees = Utilities.ValidateArray(scheduleDic["employees"] as! NSArray)
        schedule?.openShifts = Utilities.ValidateArray(scheduleDic["openShifts"] as! NSArray)
        return schedule
    }
    
    func convertToDictionary() -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(self.days, forKey: "days")
        dict.setValue(self.employees, forKey: "employees")
        dict.setValue(self.openShifts, forKey: "openShifts")
        dict.setValue(self.weekdays, forKey: "weekDays")
        return dict
    }

    func returnDays (schedule : NSScheduleWeek)  {
     schedule.weekdays = NSMutableArray()
        for var index = 1; index <= 7; ++index {
           let dayDictionary = NSMutableDictionary()
            let stringI = String(index)
            dayDictionary.setValue(schedule.days.valueForKey("day\(stringI)"), forKey:stringI)
            weekdays.addObject(dayDictionary)
        }
    }    
    
    init?() {
       self.days = NSDictionary()
       self.employees = NSArray()
       self.openShifts = NSArray()
       self.weekdays = NSMutableArray()
    }
    
    func filterShifts(weekSchedule : NSScheduleWeek, weekPeriods : NSMutableArray){
        let dayPeriodsArray = NSMutableArray()
        //go through the weekdays
        weekSchedule.weekdays.enumerateObjectsUsingBlock({ (a : AnyObject, i : Int, stop :  UnsafeMutablePointer<ObjCBool>) -> Void in
            //create dictionary with day and periods
            let dayPeriods = NSMutableDictionary()
            let shifts = NSMutableArray()
            let openShifts = NSMutableArray()
            
            //add the date to the dictionary
            dayPeriods.setValue(weekSchedule.weekdays.objectAtIndex(i).valueForKey(String(i+1)) as! String, forKey: "day")
            dayPeriods.setValue(String(i), forKey: "index")
            
            let date = Utilities.dateFromString(Utilities.removeThumbnailSufix(weekSchedule.weekdays.objectAtIndex(i).valueForKey(String(i+1)) as! String, removeCount: -1), isShortForm: true)
            //go through periods and compare their start dates with the week day
            weekPeriods.enumerateObjectsUsingBlock({ (a : AnyObject, i : Int,sop : UnsafeMutablePointer<ObjCBool>) -> Void in
                let period = weekPeriods.objectAtIndex(i) as? NSSchedulePeriod
                let startDate = Utilities.dateFromStringHours(Utilities.removeThumbnailSufix((period?.startAt)!, removeCount: -1), format: genericTimeFormat)
                if(Utilities.filterDateForWeek(date!, dateToFilter: startDate) == true){
                    shifts.addObject(period!)
                    dayPeriods.setValue(shifts, forKey: "shifts")
                }
            })
            
            //go through open shifts and add them to dayPeriod if it has the same date
            weekSchedule.openShifts.enumerateObjectsUsingBlock({ (a : AnyObject, i : Int, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                var shift = NSSchedulePeriod()
                shift = shift?.initFromDictionary(weekSchedule.openShifts.objectAtIndex(i) as! NSDictionary)
                let startDate1 = Utilities.dateFromStringHours(Utilities.removeThumbnailSufix((shift?.startAt)!, removeCount: -1),format: genericTimeFormat)
                if(Utilities.filterDateForWeek(date!, dateToFilter: startDate1) == true){
                    openShifts.addObject(shift!)
                    dayPeriods.setValue(openShifts, forKey: "openShifts")
                }
            })
            dayPeriodsArray.addObject(dayPeriods)
        })
        
        weekSchedule.weekdays = dayPeriodsArray
    }
    
    func getPeriods (weekSchedule : NSScheduleWeek) ->NSMutableArray{
    let weekPeriods = NSMutableArray()
        let employees = Utilities.ValidateArray(weekSchedule.employees)
        employees.enumerateObjectsUsingBlock({ (a : AnyObject,i : Int, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
            var employee = NSScheduleEmployee()
            let employeeDict = employees.objectAtIndex(i)
            employee = employee?.initFromDictionary(employeeDict as! NSDictionary)
            
            if(employee?.periods.count>0){
                employee?.periods.enumerateObjectsUsingBlock({ (a : AnyObject,i : Int,stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                    var period = NSSchedulePeriod()
                    let dict = employee?.periods.objectAtIndex(i) as! NSDictionary
                    period = period!.initFromDictionary(dict)
                    period!.employeePhoto = Utilities.removeThumbnailSufix((employee?.photoUrl)!,removeCount: -10)
                   weekPeriods.addObject(period!)
                })
            }
        })
        return weekPeriods
    }
        
}
