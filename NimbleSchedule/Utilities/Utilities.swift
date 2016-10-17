//
//  Utilities.swift
//  NimbleSoftWare
//
//  Created by Yosemite on 10/9/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import Foundation
import CoreLocation

public class Utilities: NSObject {
    class var sharedInstance: Utilities {
        struct Static {
            static let instance: Utilities = Utilities()
        }
        return Static.instance
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    class func isValidData(data: String?) -> Bool {
        if (data == nil || data!.isKindOfClass(NSNull)) {
            return false
        } else if (data != nil) {
            return !data!.isEmpty
        } else {
            let num:Int? = Int(data!)
            return num != nil
        }
    }
    
    class func isValidNumber(data: String?) -> Bool {
        if (data!.isKindOfClass(NSNull) || data == nil) {
            return false
        } else {
            let num:Int? = Int(data!)
            return num != nil
        }
    }
    
    class func createBorder(edge edge: UIRectEdge, colour: UIColor = UIColor.whiteColor(), thickness: CGFloat = 1, frame: CGRect = CGRectMake(0, 0, 30, 50)) -> CALayer {
        
        let border = CALayer()
        switch edge {
        case UIRectEdge.Top:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(frame), thickness)
            break
        case UIRectEdge.Bottom:
            border.frame = CGRectMake(0, CGRectGetHeight(frame) - thickness, CGRectGetWidth(frame), thickness);
            break
        case UIRectEdge.Left:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(frame))
            break
        case UIRectEdge.Right:
            border.frame = CGRectMake(CGRectGetWidth(frame) - thickness, 0, thickness, CGRectGetHeight(frame))
            break
        case UIRectEdge.None:
            break
        default:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(frame), thickness)
            break
        }
        border.backgroundColor = colour.CGColor
        return border
    }
    
    // Get Valid String
    class func getValidString(fromString: String?, defaultString: String) -> String {
        if (fromString == nil || fromString!.isEmpty) {
            return defaultString
        } else {
            return fromString!
        }
    }
    
    //Validate text fields
    class func isStringValid (fromString: String?) ->Bool{
        if(fromString == nil || fromString!.isEmpty){
        return false
        }
        else{
        return true
        }
    }
       
    
    //Validate phone
    func validate(value: String) -> Bool {
        
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        let result =  phoneTest.evaluateWithObject(value)
        
        return result
        
    }

    
    
    //validate array
    class func ValidateArray (array : NSArray) -> NSArray{
        if (array.isKindOfClass(NSNull) || array.count == 0) {
            return NSArray()
        } else {
         return array
        }
    
    }
    
    //validate array
    class func ValidateMutableArray (array : NSMutableArray) -> NSMutableArray{
        if (array.isKindOfClass(NSNull) || array.count == 0) {
            return NSMutableArray()
        } else {
            return array
        }
        
    }
    
    // Font
    class func fontWithSize(fontSize: CGFloat) -> UIFont {
        let font = UIFont.init(name: kRegularFontName, size: fontSize)
        return font!
    }
    
    class func boldFontWithSize(fontSize: CGFloat) -> UIFont {
        let font = UIFont.init(name: kBoldFontName, size: fontSize)
        return font!
    }
    
    // Alert Message
    class func showMsg(message: String, delegate: UIViewController?) {
        let alertVC = UIAlertController.init(title: kTitle_APP, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (alert: UIAlertAction!) -> Void in
            alertVC.dismissViewControllerAnimated(true, completion: nil)
        }
        alertVC.addAction(defaultAction)
        
        delegate!.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    class func showMsgWithTitle(title: String, message: String, delegate: UIViewController?) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (alert: UIAlertAction!) -> Void in
            alertVC.dismissViewControllerAnimated(true, completion: nil)
        }
        alertVC.addAction(defaultAction)
        
        delegate!.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    // Get Today Day
    class func getDay(fromDate: NSDate!) -> Int {
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "d"
        let day = Int(dateFormatter.stringFromDate(fromDate))!
        return day
    }
    
    // Check if location service is enabled
    class func isLocationServiceEnabled() -> Bool {
        if  !CLLocationManager.locationServicesEnabled() ||
            CLLocationManager.authorizationStatus() == .NotDetermined ||
        CLLocationManager.authorizationStatus() == .Denied ||
        CLLocationManager.authorizationStatus() == .Restricted{
            return false
        }
        
        return true
    }
    
    
    
    // Date Utils
    class func dateFromString(dateString: String?, isShortForm: Bool) -> NSDate? {
        if dateString == nil {
            return nil
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = isShortForm ? "yyyy'-'MM'-'dd'T'HH':'mm':'ss" : "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        
        var date = dateFormatter.dateFromString(dateString!)
        
        let localTimeZone = NSTimeZone.localTimeZone()
        let utcTimeZone = NSTimeZone.init(abbreviation: "UTC")
        
        let curGMTOffset = localTimeZone.secondsFromGMTForDate(date!)
        let utcOffset = utcTimeZone?.secondsFromGMTForDate(date!)
        let gmtInterval = curGMTOffset - utcOffset!
        
        date = NSDate.init(timeInterval: NSTimeInterval.init(gmtInterval), sinceDate: date!)
        
        return date!
    }
    
    // Date Utils
    class func dateFromStringLocal(dateString: String?, isShortForm: Bool) -> NSDate? {
        if dateString == nil {
            return nil
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = isShortForm ? "yyyy'-'MM'-'dd'T'HH':'mm':'ss" : "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: SharedDataManager.sharedInstance.offset*60)
        let date = dateFormatter.dateFromString(dateString!)
        return date!
    }
    
    
    
    
    class func stringFromDateUserTimezone (date: NSDate?, format : String) -> AnyObject {
        if date == nil {
            print("date conversion failed")
            return NSNull()
        }else{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = format
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: SharedDataManager.sharedInstance.offset*60)
            print(dateFormatter.stringFromDate(date!))
            return dateFormatter.stringFromDate(date!)
        }
    }
    
    //convert string to UTC date then to user timezone string
    class func convertPeriodHours (date : String) -> String {
        
        let dateFormatted = self.removeThumbnailSufix(date, removeCount: -1)
        let dateConvert = self.dateFromString(dateFormatted, isShortForm: true)
        let LocalString = self.stringFromDateUserTimezone(dateConvert, format: hoursTimeFormat) as! String
        return LocalString
    }

   //add days to day
    class func addDaysToDate (dayNumber : NSInteger, date : NSDate) -> NSDate{
   
        let dateComponents = NSDateComponents()
        dateComponents.day = dayNumber
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: date, options: NSCalendarOptions(rawValue: 0))!
    }
    
    class func stringFromDate(date: NSDate?, isShortForm: Bool) -> AnyObject {
        if date == nil {
              print("date conversion failed")
            return NSNull()
        }else{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = isShortForm ? "yyyy'-'MM'-'dd'T'HH':'mm':'ss" : "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
            dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")
        print(dateFormatter.stringFromDate(date!))
        return dateFormatter.stringFromDate(date!)
        }
    }
    
    

    //get week and days based on date
    class func daysInWeek (weekOffset : NSInteger, date : NSDate) -> NSArray{
    
        //get current week
        let calendar = NSCalendar.currentCalendar()
        var comps = NSDateComponents()
        comps = calendar.components(NSCalendarUnit.Year, fromDate: date)
        comps.weekOfYear = weekOffset
        
        //calculate monday
        let weekStart =  self.getFirstDay(weekOffset, year: comps.year)
        
        var StringPrefix : String = ""
        //add 7 days
        let week = NSMutableArray(capacity: 7)
        var i : Int
        for  i = 1 ; i <= 7 ; ++i {
        let compsToAdd = NSDateComponents()
        compsToAdd.day = i
                        if(i == 1 ){
            StringPrefix = NSLocalizedString("MON", comment: "MON")
            }
            else if (i == 2){
                StringPrefix = NSLocalizedString("TUE", comment: "TUE")
            }
            else if (i == 3){
                StringPrefix = NSLocalizedString("WED", comment: "WED")
            }
            else if (i == 4){
                StringPrefix = NSLocalizedString("THU", comment: "THU")
            }
            else if (i == 5){
                StringPrefix = NSLocalizedString("FRI", comment: "FRI")
            }
            else if (i == 6){
                StringPrefix = NSLocalizedString("SAT", comment: "SAT")
            }
            else if (i == 7){
                StringPrefix = NSLocalizedString("SUN", comment: "SUN")
            }
            let nextDate = calendar.dateByAddingComponents(compsToAdd, toDate: weekStart!, options: NSCalendarOptions.MatchNextTimePreservingSmallerUnits)
            week.addObject(nextDate!)

        }
        return week
    }
    
    class func getFirstDay(weekNumber:Int , year : Int)->NSDate?{
        let Calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let dayComponent = NSDateComponents()
        dayComponent.weekOfYear = weekNumber+1
        dayComponent.weekday = 1
        dayComponent.year = year
        let date = Calendar.dateFromComponents(dayComponent)
        
       /* if(weekNumber == 1 && Calendar.components(.Month, fromDate: date!).month != 1){
            print(Calendar.components(.Month, fromDate: date!).month)
            dayComponent.year = 2016
            date = Calendar.dateFromComponents(dayComponent)
        }*/

        return date
    }
    
    class func getWeek(today:NSDate) -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
        let myComponents = myCalendar.components(.WeekOfYear, fromDate: today)
        let weekNumber = myComponents.weekOfYear
        return weekNumber
    }
    
    
    class func dateFromStringLocal (dateString : String?, format : String) -> NSDate{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: SharedDataManager.sharedInstance.offset*60)
        let date = dateFormatter.dateFromString(dateString!)        
        return date!

    }
    
    class func stringFromDate(date: NSDate?, formatStr: String) -> String {
        if date == nil {
            return "None"
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatStr
        dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")
//        let localTimeZone = NSTimeZone.localTimeZone()
//        let utcTimeZone = NSTimeZone.init(abbreviation: "UTC")
//        
//        let curGMTOffset = localTimeZone.secondsFromGMTForDate(date)
//        let utcOffset = utcTimeZone?.secondsFromGMTForDate(date)
//        let gmtInterval = utcOffset! + curGMTOffset
//        
//        let newDate = NSDate.init(timeInterval: NSTimeInterval.init(gmtInterval), sinceDate: date)
        
        return dateFormatter.stringFromDate(date!)
    }
    
    class func stringFromDateNoTimezone(date: NSDate?, formatStr: String) -> String {
        if date == nil {
            return "None"
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatStr
       let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        // Swift 2:
        let components = calendar.components([.Day , .Month, .Year ], fromDate: date!)
          components.hour=0
         components.minute=0
         components.second=0
        let newDate = calendar.dateFromComponents(components)
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = formatStr
        dateFormatter1.timeZone = NSTimeZone(forSecondsFromGMT: -SharedDataManager.sharedInstance.offset*60)
        
        return dateFormatter1.stringFromDate(newDate!)
    }
    
    
    
    class func dateFromStringHours (stringDate : String, format : String) ->NSDate {
    let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
       //dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")
        return dateFormatter.dateFromString(stringDate)!
    }
    
    class func stringFromDateHours (date : NSDate, format : String) -> String{
   
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!        
        // Swift 2:
        let components = calendar.components([.Day , .Month, .Year ], fromDate: date)
        components.hour=0
        components.minute=0
        components.second=0
        let newDate = calendar.dateFromComponents(components)
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = format
        dateFormatter1.timeZone = NSTimeZone(forSecondsFromGMT: -SharedDataManager.sharedInstance.offset*60)
        
        return dateFormatter1.stringFromDate(newDate!)

    }
    
    class func dateWithUTCTimeZone(date: NSDate) -> NSDate {
        let localTimeZone = NSTimeZone.localTimeZone()
        let utcTimeZone = NSTimeZone.init(abbreviation: "UTC")
        
        let curGMTOffset = localTimeZone.secondsFromGMTForDate(date)
        let utcOffset = utcTimeZone?.secondsFromGMTForDate(date)
        let gmtInterval = curGMTOffset - utcOffset!
        
        let newDate = NSDate.init(timeInterval: NSTimeInterval.init(gmtInterval), sinceDate: date)
        return newDate
    }
    
    // Create warning view by adding red borders
    class func putWarningStatus( view: AnyObject) {
        view.layer.borderColor = UIColor.redColor().CGColor
        view.layer.borderWidth = 1.0
    }
    
    
    class func removeWarningStatus(view: AnyObject) {
        view.layer.borderWidth = 0
    }
    class func capitalLetterTextField (textfield : UITextField){
    textfield.autocapitalizationType = UITextAutocapitalizationType.Words
    }
    
    //shake animation
    class func shakeView(view : AnyObject){
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let from_point:CGPoint = CGPointMake(view.center.x - 5, view.center.y)
        let from_value:NSValue = NSValue(CGPoint: from_point)
        
        let to_point:CGPoint = CGPointMake(view.center.x + 5, view.center.y)
        let to_value:NSValue = NSValue(CGPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        view.layer.addAnimation(shake, forKey: "position")
    }
    
    // Remove seperator TableView
    class func decorateTableView(tableView: UITableView) {
        tableView.tableFooterView = UIView()
    }
    
    //touch identification default info
    class func setFingerprintLoginInfo (username : String, password : String){
        NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
        NSUserDefaults.standardUserDefaults().setValue(password, forKey: "password")
    }
    
    class func getDefaultPassword() -> String {
        let password = NSUserDefaults.standardUserDefaults().valueForKey("password") as! String!
        if self.isStringValid(password) == true {
        return password
        }
        else{
        return ""
        }
    }
    
    class func getDefaultUsername() -> String {
    let username = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String!
          if self.isStringValid(username) == true {
            return username
        }
        else{
            return ""
        }
    }
    
    // Creates a UIColor from a Hex string.
    class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    //remove thumbnail from image link
    class func removeThumbnailSufix(url : String, removeCount : NSInteger) -> String{
        let index = url.endIndex.advancedBy(removeCount)
        return url.substringToIndex(index)
    }
         
    //TEMPORARY
   class func setDayName (index : NSInteger) -> String{
        var name : String = ""
        if(index == 0){
            name = NSLocalizedString("Monday", comment: "Monday")
        }
        else if (index == 1){
           name = NSLocalizedString("Tueday", comment: "Tueday")
        }
        else if (index == 2){
            name = NSLocalizedString("Wednesday"
                , comment: "Wednesday")
        }
        else if (index == 3){
         name = NSLocalizedString("Thursday", comment: "Thursday")
    }
        else if (index ==  4){
         name = NSLocalizedString("Friday", comment: "Friday")
    }
        else if (index == 5){
        name = NSLocalizedString("Saturday", comment: "Saturday")
      }
        else if (index == 6){
        name = NSLocalizedString("Sunday", comment: "Sunday")
     }
        return name
    }
   
    //compare  2 dates
    class func filterDateForWeek (var dayOfWeek : NSDate , var dateToFilter : NSDate)->Bool{
        //convert dates to local time with year and date only
       let calendar = NSCalendar.currentCalendar()
        let unitFlags: NSCalendarUnit = [ .Day, .Month, .Year]
        
        let  dayOfWeekComponents = NSCalendar.currentCalendar().components(unitFlags,  fromDate: dayOfWeek)
        dayOfWeekComponents.hour=0
        dayOfWeekComponents.minute=0
        dayOfWeekComponents.timeZone = NSTimeZone(forSecondsFromGMT: SharedDataManager.sharedInstance.offset*60)
        dayOfWeek = (calendar.dateFromComponents(dayOfWeekComponents))!
        
        let  dateToFilterComponents = NSCalendar.currentCalendar().components(unitFlags,  fromDate: dateToFilter)
        dateToFilterComponents.hour=0
        dateToFilterComponents.minute=0
        dateToFilterComponents.timeZone = NSTimeZone(forSecondsFromGMT: SharedDataManager.sharedInstance.offset*60)
        dateToFilter = (calendar.dateFromComponents(dateToFilterComponents))!
        
        if(dayOfWeek.isEqualToDateSelected(dateToFilter)){
        return true
        }
        else{         
        return false
          
        }
        
    }
        
  
}
extension NSDate
{
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    func isEqualToDateSelected(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame
        {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    
    
    func addDays(daysToAdd : Int) -> NSDate
    {
        let secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func getCurrentMillis()->Int{
        return  Int(self.timeIntervalSince1970 * 60)
    }
    
    
    func addHours(hoursToAdd : Int) -> NSDate
    {
        let secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
   
}
