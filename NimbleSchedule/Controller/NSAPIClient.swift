//
//  APIController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 10/15/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import Foundation

class NSAPIClient: AFHTTPRequestOperationManager {
    
//    class var sharedInstance: NSAPIClient {
//        struct Static {
//            static let instance: NSAPIClient = NSAPIClient()
//        }
//        return Static.instance
//    }
    
    class var sharedInstance: NSAPIClient {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: NSAPIClient? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = NSAPIClient()
//            Static.instance?.securityPolicy.allowInvalidCertificates = true
            Static.instance?.requestSerializer = AFHTTPRequestSerializer()
            Static.instance?.responseSerializer = AFHTTPResponseSerializer()
          
            let header = SharedDataManager.sharedInstance.accessToken
            let encodedHeader = "Bearer \(header!)"
            
            Static.instance?.requestSerializer.setValue(encodedHeader, forHTTPHeaderField: "Authorization")
        }
        
        return Static.instance!
    }
    
    class var authInstance: NSAPIClient {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: NSAPIClient? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = NSAPIClient()
            //            Static.instance?.securityPolicy.allowInvalidCertificates = true
            Static.instance?.requestSerializer = AFHTTPRequestSerializer()
            Static.instance?.responseSerializer = AFHTTPResponseSerializer()
            
            // Set Http Header with ClientId and ClientSecret
            let header = "\(CLIENT_ID):\(CLIENT_SECRET)"
            let plainData = header.dataUsingEncoding(NSUTF8StringEncoding)
            let base64String = plainData?.base64EncodedString()
            let encodedHeader = "Basic \(base64String!)"
            
            Static.instance?.requestSerializer.setValue(encodedHeader, forHTTPHeaderField: "Authorization")
        }
        
        return Static.instance!
    }
    
    // POST api call
    private func postTo(resource:String?, parameter:NSDictionary?, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        print(parameter)
        var url = "\(SERVER_API_URL)/\(resource!)"
        print("request url=\(url)")
        if (self == NSAPIClient.authInstance) {
            url = "\(SERVER_AUTH_URL)/\(resource!)"
        }
        self.POST(url, parameters: parameter, success: { (operation, object) -> Void in
            
            do {
                let parseData = try NSJSONSerialization.JSONObjectWithData(operation.responseData!, options: []) as! [String:AnyObject]
                // use anyObj here
                callback(nsData: parseData, error:nil)

            } catch {
                print(operation.response?.statusCode)
                if (operation.response?.statusCode == 200) {
                    callback(nsData: nil, error:nil)
                }
                print("json error: \(error)")
            }
            
            }) { (operation, error) -> Void in
                callback(nsData: nil, error:error)
        }
    }
    
    // Fetch Json with GET method call
    private func fetchJSON(resource:String?, parameter:NSDictionary?, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        print(parameter)
        let url = "\(SERVER_API_URL)/\(resource!)"
        print("request url=\(url)")
        self.GET(url, parameters: parameter, success: { (operation, object) -> Void in
            
            do {
                let parseData = try NSJSONSerialization.JSONObjectWithData(operation.responseData!, options: []) as! [String:AnyObject]
                // use anyObj here
                callback(nsData: parseData, error:nil)
                
            } catch {
                print("json error: \(error)")
            }
            
            }) { (operation, error) -> Void in
                callback(nsData: nil, error:error)
        }
    }
    
    // PUT api call
    private func putTo(resource:String?, parameter:NSDictionary?, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        print(parameter)
        let url = "\(SERVER_API_URL)/\(resource!)"
        print("request url=\(url)")
        self.PUT(url, parameters: parameter, success: { (operation, object) -> Void in
            
            do {
                let parseData = try NSJSONSerialization.JSONObjectWithData(operation.responseData!, options: []) as! [String:AnyObject]
                // use anyObj here
                callback(nsData: parseData, error:nil)
                
            } catch {
                print("json error: \(error)")
            }
            
            }) { (operation, error) -> Void in
                callback(nsData: nil, error:error)
        }
    }
    
    // DELETE api call
    private func deleteTo(resource:String?, parameter:NSDictionary?, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        print(parameter)
        let url = "\(SERVER_API_URL)/\(resource!)"
        print("request url=\(url)")
        self.DELETE(url, parameters: parameter, success: { (operation, object) -> Void in
            
            do {
                let parseData = try NSJSONSerialization.JSONObjectWithData(operation.responseData!, options: []) as! [String:AnyObject]
                // use anyObj here
                callback(nsData: parseData, error:nil)
                
            } catch {
                print("json error: \(error)")
            }
            
            }) { (operation, error) -> Void in
                callback(nsData: nil, error:error)
        }
    }
    
    // Upload Photo
    private func uploadTo(resource: String?, postData: NSDictionary?, fileInfo: NSDictionary?, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
//        let tmpFileName = NSString.init(format: "%f", NSDate.timeIntervalSinceReferenceDate())
//        let tmpFileUrl = NSURL.fileURLWithPath(NSTemporaryDirectory().stringByAppendingString(tmpFileName as String))
//        var error : NSError?
//        var request = AFJSONRequestSerializer().multipartFormRequestWithMethod("POST", URLString: "\(SERVER_API_URL)/\(resource)", parameters: postData, constructingBodyWithBlock: { (formData:AFMultipartFormData!) -> Void in
////            if formData.appendPartWithFileURL(self.imageURL, name: "negotiation[image]", fileName: "image.jpeg", mimeType: "image/jpeg", error: nil){
////                NSLog("File added to form data")
////            } else {
////                NSLog("Error adding file to form Data: %@", error!.localizedDescription)
////            }
//            }, error: &error)
//        
//        AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: "\(SERVER_API_URL)/\(resource)", parameters: postData, constructingBodyWithBlock: { (formData: AFMultipartFormData) -> Void in
//            
//            }, error: &error)
//        
//        let multipartRequest = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: "\(SERVER_API_URL)/\(resource)", parameters: postData, { (formData: AFMultipartFormData!) -> Void in
//            
//        })
    }
    
    // Login API
    func signIn(username: String?, password: String?, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        let param = ["username":username!, "password":password!, "grant_type":"password", "scope":"NimbleScheduleApi offline_access", "response_type":"token"]
        
        self.postTo(kLoginAPI, parameter: param) { (nsData, error) -> Void in
            // Register Access Token
            print(nsData)
            if (error == nil) {
                SharedDataManager.sharedInstance.accessToken = (nsData as! NSDictionary)["access_token"]  as! String
                SharedDataManager.sharedInstance.userName = username
                SharedDataManager.sharedInstance.password = password
                SharedDataManager.sharedInstance.isLoggedIn = true
                
                SharedDataManager.sharedInstance.saveUserInfo()
            }
            callback(nsData: nsData, error: error)
        }
    }
    
    // Get User Setting API
    func getUserSettings(callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        self.fetchJSON(kUserSettingsAPI, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    //get countries
    func getCountryList(callback:((nsData:AnyObject?, error: NSError?) -> Void)){
       self.fetchJSON(kGetLocationCountries, parameter: nil) { (nsData, error) -> Void in
           callback(nsData: nsData, error: error)
        }
    }
    
    //get timezones
    func getTimeZones(callback:((nsData:AnyObject?, error: NSError?) -> Void)){
    self.fetchJSON(kGetLocationTimezones, parameter: nil) { (nsData, error) -> Void in
           callback(nsData: nsData, error: error)
        }
    }
    
    //get country states
      func getStates(countryId : String,callback:((nsData:AnyObject?, error: NSError?) -> Void)){
               let formattedString = "/lookup/countries/"+countryId+"/states"
          self.fetchJSON(formattedString, parameter: nil) { (nsData, error) -> Void in
               callback(nsData: nsData, error: error)
            print(nsData)
        }
    }
    
    
    
    // Get Positions for Employee
    func getPositionListWithEmployeeId(employeeId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString(format: kGetPositionListForEmployeeIdAPI, employeeId) as String
        
        self.fetchJSON(url, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    //-------------------------------- Shift -------------------------------------//
    func createShift(title: String, startAt: String, endAt: String, repeatDict: NSDictionary, locationId: String, positionId: String, employeeArray: NSArray, isOpenShift: Bool, notes: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let param = [
            "title": title,
            "startAt": startAt,
            "repeat": repeatDict,
            "locationId": locationId,
            "positionId": positionId,
            "employeIds": employeeArray,
            "publishShift": isOpenShift,
            "notes": notes
        ]
        
        self.postTo(kScheduleAPI, parameter: param) { (nsData, error) -> Void in
        }
        
    }

    // Get a Schedule for a specific day
    func getScheduleForDay(filter : NSScheduleFilterDay,callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let param = NSMutableDictionary()
        if(Utilities.isStringValid(filter.startAt)){
            param.setValue(filter.startAt, forKey: "startAt")
        }
        if(Utilities.isStringValid(filter.locationId)){
            param.setValue(filter.locationId, forKey: "locationId")
        }
        if(Utilities.isStringValid(filter.positionId)){
            param.setValue(filter.positionId, forKey: "positionId")
        }
        if(Utilities.isStringValid(filter.employeeId)){
            param.setValue(filter.employeeId, forKey: "employeeId")
        }
        let paramsString = param.stringFromHttpParameters()
        let combinedUrl = "\(kGetScheduleForDay)?filter=\(paramsString)"
        self.fetchJSON(combinedUrl, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }

    }
 
    // Get a Schedule for a specific week
    func getScheduleForWeek(filter : NSScheduleFilterWeek, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        let param = NSMutableDictionary()
        if(Utilities.isStringValid(filter.currentDate)){
        param.setValue(filter.currentDate, forKey: "currentDate")
        }
        if(Utilities.isStringValid(filter.locationId)){
        param.setValue(filter.locationId, forKey: "locationId")
        }
        if(Utilities.isStringValid(filter.positionId)){
        param.setValue(filter.positionId, forKey: "positionId")
        }
        if(Utilities.isStringValid(filter.employeeId)){
        param.setValue(filter.employeeId, forKey: "employeeId")
        }
        let paramsString = param.stringFromHttpParameters()
        let combinedUrl = "\(kGetScheduleForWeek)?filter=\(paramsString)"
        self.fetchJSON(combinedUrl, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)     
        }
    }
    
    //Get schedule for a specific month
    func getScheduleForMonth(filter : NSScheduleFilterWeek, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        let param = NSMutableDictionary()
        if(Utilities.isStringValid(filter.currentDate)){
            param.setValue(filter.currentDate, forKey: "currentDate")
        }
        if(Utilities.isStringValid(filter.locationId)){
            param.setValue(filter.locationId, forKey: "locationId")
        }
        if(Utilities.isStringValid(filter.positionId)){
            param.setValue(filter.positionId, forKey: "positionId")
        }
        if(Utilities.isStringValid(filter.employeeId)){
            param.setValue(filter.employeeId, forKey: "employeeId")
        }
        let paramsString = param.stringFromHttpParameters()
        let combinedUrl = "\(kGetScheduleForWeek)?filter=\(paramsString)"
        self.fetchJSON(combinedUrl, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    //get user schedule
    func getScheduleForUser(filter : NSUserScheduleFilter, callback:((nsData:AnyObject?, error: NSError?) -> Void)){
        let param = NSMutableDictionary()
        if(Utilities.isStringValid(filter.startAt)){
            param.setValue(filter.startAt, forKey: "startAt")
        }
        if(Utilities.isStringValid(filter.scheduleViewType)){
            param.setValue(filter.scheduleViewType, forKey: "scheduleViewType")
        }

        let paramsString = param.stringFromHttpParameters()
        let combinedUrl = "\(kGetScheduleForUser)?filter=\(paramsString)"
        self.fetchJSON(combinedUrl, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }        
    }

    
    //-------------------------------- Time Clock -------------------------------------//
    // Get TimeClock State 
    func getTimeClockState(callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        self.fetchJSON(kGetTimeClockStateAPI, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    func clockInWithEmploymentId(employmentId: String, latitude: Double, longitude: Double, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let param = ["EmploymentId": employmentId, "LatitudeClockIn": latitude, "LongitudeClockIn": longitude]
        
        self.postTo(kClockInEmployeeAPI, parameter: param) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }

    func clockOutWithClockInId(clockInId: String, latitude: Double, longitude: Double, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString(format: kClockOutEmployeeAPI, clockInId) as String
        let param = ["Latitude": latitude, "Longitude": longitude]
        
        self.postTo(url, parameter: param) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // ---------------------------------- Locations ---------------------------------------//
    // Get Location list
    func getLocationList(callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        self.fetchJSON(kGetLocationListAPI, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // Get Location Detail
    func getLocationDetailWithLocationId(locationId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
    
        let url = NSString.init(format: kGetLocationDetailAPI, locationId)
        self.fetchJSON(url as String, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    //Get Location Managers
    
    func getLocationManagers(locationId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString.init(format: kGetLocationManagers, locationId)
        self.fetchJSON(url as String, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    
    // Create Location
    func createLocation(name: String, country: String, addressLine1: String, addressLine2: String, city: String, zipCode: String, phoneNumber: String,primary : Bool, inactive : Bool,timeZone : String,state : String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
     
        
        let param = [
            "Name": name,
            "Country": country,
            "AddressLine1": addressLine1,
            "AddressLine2": addressLine2,
            "City": city,
            "ZipCode": zipCode,
            "Phone": phoneNumber,
            "State": state,
            "TimeZone": timeZone,
            "Primary" : self.boolString(primary),
            "Inactive" : self.boolString(inactive),
        ]
        
        self.postTo(kGetLocationListAPI, parameter: param) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    func boolString (boolValue : Bool) -> String{
        var stringValue : String
        if (boolValue == true)
        {
        stringValue = "true"
        }
        else{
        stringValue = "false"
        }
       return stringValue
    }

    // Update Location
    func updateLocationWithLocationId(locationId: String, name: String, country: String, addressLine1: String, addressLine2: String, city: String, zipCode: String, phoneNumber: String,primary : Bool, inactive : Bool,timezone : String, state : String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let param = [
            "Name": name,
            "Country": country,
            "AddressLine1": addressLine1,
            "AddressLine2": addressLine2,
            "City": city,
            "ZipCode": zipCode,
            "Phone": phoneNumber,
            "State": state,
            "TimeZone": timezone,
            "Primary": self.boolString(primary),
            "Inactive": self.boolString(inactive)
        ]
        
        let url = NSString.init(format: kGetLocationDetailAPI, locationId)
        
        self.postTo(url as String, parameter: param) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    
    // Delete Location
    func deleteLocationWithLocationId(locationId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        let url = NSString(format: kGetLocationDetailAPI, locationId) as String
        self.deleteTo(url, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }

    // Remove manager from Location
    func deleteManagerWithLocationId(locationId: String, employeeId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString(format: kRemoveManagerInLocationAPI, locationId) as String
        self.postTo(url, parameter: ["EmployeeId": employeeId]) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // Add manager to Location
    func addManagerWithLocationId(locationId: String, employeeId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString(format: kAddManagerToLocationAPI, locationId) as String
        self.postTo(url, parameter: ["EmployeeId": employeeId]) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // Update Hours of Operation in Location
    func updateHoursOfOperationWithLocationId(locationId: String, hoursOperationData: NSHoursOperation, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString(format: kUpdateHoursOfOperation, locationId) as String
        self.postTo(url, parameter: hoursOperationData.convertToDictionary()) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }

    
    // ---------------------------------- Positions ---------------------------------------//
    // Get Position list
    func getPositionList(callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        self.fetchJSON(kGetPositionListAPI, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    func getPositionDetailWithPositionId(positionId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString(format: kGetPositionDetailAPI, positionId) as String

        self.fetchJSON(url, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    func createPositionWithName(positionName: String, positionColor: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let param = ["Name" : positionName, "Color" : positionColor]
        self.postTo(kGetPositionListAPI, parameter: param) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // ---------------------------------- Employees ---------------------------------------//
    // Create Employee with Personal Information
    func createEmployee(firstName: String, lastName: String, email: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let param = ["FirstName" : firstName, "LastName" : lastName, "Email" : email, "UserName" : "\(firstName)\(lastName)", "HireDate" : Utilities.stringFromDate(NSDate(), isShortForm: false), "TimeZone" : NSTimeZone.systemTimeZone().name]
        
        self.postTo(kGetEmployeeListAPI, parameter: param) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    // Get Employee list
    func getEmployeeList(callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        self.fetchJSON(kGetEmployeeListAPI, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // Get Employee's Employments list
    func getEmploymentListWithEmployeeId(employeeId: String,callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString.init(format: kCreateEmployeePositionAPI, employeeId)

        self.fetchJSON(url as String, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }

    
    // Get Employee Detail
    func getEmployeeDetailWithEmployeeId(employeeId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString.init(format: kGetEmployeeDetailAPI, employeeId)
        
        self.fetchJSON(url as String, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // Get Employee ContactInfo
    func getEmployeeContactInfoWithEmployeeId(employeeId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString.init(format: kGetEmployeeContactInfoAPI, employeeId)
        
        self.fetchJSON(url as String, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // Update Employee ContactInfo
    func updateEmployeeWithEmployeeId(employeeId: String, firstName: String, lastName: String, email: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString.init(format: kGetEmployeeDetailAPI, employeeId)
        
        let param = ["firstName" : firstName,
            "lastName" : lastName,
            "email" : email,
            "username" : "\(firstName)\(lastName)",
            "HireDate" : Utilities.stringFromDate(NSDate(), isShortForm: false),
            "TimeZone" : NSTimeZone.systemTimeZone().name
        ]
        
        self.postTo(url as String, parameter: param) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // Update Employee ContactInfo
    func updateEmployeeContactInfoWithEmployeeId(employeeId: String, addressLine1: String, addressLine2: String, city: String, state: String, zipCode: String, mobile: String, country: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString.init(format: kUpdateEmployeeContactInfoAPI, employeeId)
        
        let param = ["addressLine1" : addressLine1,
                    "addressLine2" : addressLine2,
                    "city" : city,
                    "state" : state,
                    "zipCode" : zipCode,
                    "mobile" : mobile,
                    "country" : country]
        
        self.postTo(url as String, parameter: param) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // Create Employee Position
    func createEmployeePositionWithEmployeeId(employeeId: String, locationId: String, positionId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
    
        let url = NSString(format: kCreateEmployeePositionAPI, employeeId) as String
        let param = ["PositionId" : positionId, "LocationId" : locationId]
        self.postTo(url, parameter: param) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // Delete Employee
    func deleteEmployeeWithEmployeeId(employeeId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString(format: kGetEmployeeDetailAPI, employeeId) as String
        self.deleteTo(url, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
    
    // Delete Employee Position
    func deleteEmployeePositionWithPositionId(positionId: String, callback:((nsData:AnyObject?, error: NSError?) -> Void)) {
        
        let url = NSString(format: kDeleteEmployeePosition, positionId) as String
        self.deleteTo(url, parameter: nil) { (nsData, error) -> Void in
            callback(nsData: nsData, error: error)
        }
    }
}

extension String {
    

    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
    
}

extension NSMutableDictionary {

    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey):\(percentEscapedValue);"
        }
        
        return parameterArray.joinWithSeparator("")
    }
    
}
