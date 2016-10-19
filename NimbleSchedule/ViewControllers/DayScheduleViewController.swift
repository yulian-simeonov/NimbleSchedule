//
//  DayScheduleViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 10/28/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayNumLabel: UILabel!
    @IBOutlet weak var dayWeekLabel: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        if (selected) {
            self.contentView.backgroundColor = MAIN_COLOR
        } else {
            self.contentView.backgroundColor = GRAY_COLOR_4
        }
    }
}

protocol DayScheduleViewControllerDelegate {
    func shiftDidSelect(shiftObj: NSShift)
}

class DayScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSMyScheduleViewDelegate {

    var delegate: DayScheduleViewControllerDelegate? = nil
    
    @IBOutlet weak var dayTable: UITableView!
    @IBOutlet weak var myScheduleView: NSMyScheduleView!
    @IBOutlet weak var shiftTable: UITableView!

    var isFromRequest: Bool = false
    
    // View Mode
    var viewMode: EScheduleViewMode!
    
    // Define
    let rightPadding = 10 as CGFloat!
    let topPadding = 50 as CGFloat!
    let stepHei = 60 as CGFloat!
    let labelWid = 50 as CGFloat!
    
    var dateArray: NSMutableArray!
    var calendar = NSCalendar.currentCalendar()
    var curIndexPath: NSIndexPath!
    var refreshControl:UIRefreshControl!
    var lastContentOffset: CGFloat!
    var isGoPrevious: Bool! = false
    var isGoNext: Bool! = false
    
    var filter : NSScheduleFilterDay!
    var schedule : NSScheduleDay!
    var userFilter : NSUserScheduleFilter!
    var userSchedule : NSScheduleUser!
    
   
    
    var periods : NSMutableArray!
    
    override  func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.x
        self.calendar = NSCalendar.autoupdatingCurrentCalendar()
        self.calendar.locale = NSLocale.currentLocale()
       
        self.generateDays()
        
        self.curIndexPath = NSIndexPath.init(forRow: 0, inSection: 0)
        self.dayTable.selectRowAtIndexPath(self.curIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        
        // Set EveryOne Shift Table
        self.shiftTable.registerNib(UINib.init(nibName: "ShiftTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "ShiftTableCell")
        self.shiftTable.registerNib(UINib.init(nibName: "OpenShiftTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "OpenShiftTableCell")
        
        
        //add refresh notification, observe if the schedule should get user or everyone day schedule
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshScheduleData:", name: "RefreshTag", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshDayTable:", name: "RefreshDayTable", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshUserDayTable:", name: "RefreshUserScheduleUser", object: nil)
        
        self.schedule = NSScheduleDay()
        self.periods =  NSMutableArray()
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
//        self.dayTable.addSubview(refreshControl)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
            //  self.filter = SharedDataManager.sharedInstance.dayScheduleFilter
      //  self.userFilter = SharedDataManager.sharedInstance.userScheduleFilter
        if(SharedDataManager.sharedInstance.shouldGetUserInfo == true){
        self.refreshUserSchedule()           
        }
        else{
            self.refreshDaySchedule()
        }
          self.updateTitle()
    }
    
    func generateDays(){
        // Set Calendar
        let today = Utilities.dateFromStringHours(SharedDataManager.sharedInstance.chosenCalendarDate, format: genericTimeFormat)
        dateArray = NSMutableArray.init(object: today)
        dateArray.addObjectsFromArray(self.generateDays(today, isForward: true, numberOfDays: 30) as [AnyObject])
        self.dayTable.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Draw Timeline
        
        
      /*  let shift = NSShift.init()
        shift?.title = "San Diego HQ"
        shift?.employeeName = "Account Manager"
        shift?.startAt = NSDate.init(timeIntervalSince1970: 30*60)
        shift?.endAt = NSDate.init(timeIntervalSince1970: 60*60)
        shift?.color = Utilities.colorWithHexString("#13e0cf")

        let shift1 = NSShift.init()
        shift1?.title = "San Diego HQ"
        shift1?.employeeName = "Account Manager"
        shift1?.startAt = NSDate.init(timeIntervalSince1970: 180*60)
        shift1?.endAt = NSDate.init(timeIntervalSince1970: 330*60)
        shift1?.color = Utilities.colorWithHexString("#fb932e")
        
        self.myScheduleView.drawLine()
        self.myScheduleView.delegate = self
        self.myScheduleView.addShift(shift!)
        self.myScheduleView.addShift(shift1!)
      */
     
     
   
    }

    func drawShifts(){
        self.myScheduleView.drawLine()
        self.myScheduleView.delegate = self
      let shifts = self.userSchedule.shifts as NSArray
        if(shifts.count>0){
            shifts.enumerateObjectsUsingBlock({ (a : AnyObject,i : Int,stop : UnsafeMutablePointer<ObjCBool>) -> Void in
            let shift = shifts.objectAtIndex(i) as! NSDictionary
                let shiftCell = NSShift.init()
                shiftCell?.title = Utilities.getValidString(shift["locationName"] as? String, defaultString: "Unknown")
                shiftCell?.employeeName = Utilities.getValidString(shift["positionName"] as? String, defaultString: "Unknown")
                shiftCell?.startAt = Utilities.dateFromStringLocal(Utilities.removeThumbnailSufix((shift["startAt"] as? String)!, removeCount: -1), format: genericTimeFormat)
                shiftCell?.endAt = Utilities.dateFromStringLocal(Utilities.removeThumbnailSufix((shift["endAt"] as? String)!, removeCount: -1), format: genericTimeFormat)
                shiftCell?.color = UIColor.blueColor()
                self.myScheduleView.addShift(shiftCell!)
                self.myScheduleView.layoutIfNeeded()
        })
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButtonAction
    
    @IBAction func onClickFilter(sender: AnyObject) {
        SharedDataManager.sharedInstance.scheduleVC.showShiftFilter()
    }
    
    // MARK: - UIRefresh Delegate
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        self.refreshControl.endRefreshing()
        
    }
    
    // MARK: - Utitility Functions
    func generateDays(fromDate: NSDate!, isForward: Bool, numberOfDays: Int) -> NSArray {
        let offset = NSDateComponents()
        let array = NSMutableArray.init(capacity: numberOfDays)
        var nextDay: NSDate! = fromDate
        for i in 1 ... numberOfDays {
            offset.day = isForward ? i : Int(i - numberOfDays + 1)
            nextDay = self.calendar.dateByAddingComponents(offset, toDate: fromDate, options: NSCalendarOptions(rawValue: 0))
            
            array.addObject(nextDay!)
        }
        return array
    }
    
    func updateTitle() {
        let curDate = self.dateArray[self.curIndexPath.section]
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "MMMM yyyy"
        print(dateformatter.stringFromDate(curDate as! NSDate))
        print(SharedDataManager.sharedInstance.scheduleVC)
        SharedDataManager.sharedInstance.scheduleVC.title = dateformatter.stringFromDate(curDate as! NSDate)
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.filter = NSScheduleFilterDay()
        if (tableView == dayTable) {
            self.curIndexPath = indexPath
            self.updateTitle()
            let curDate = self.dateArray[self.curIndexPath.section]
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = genericTimeFormat
            if(SharedDataManager.sharedInstance.shouldGetUserInfo == true){
                
                SharedDataManager.sharedInstance.chosenCalendarDate = Utilities.stringFromDateNoTimezone(curDate as? NSDate, formatStr: genericTimeFormat)
                
            }
            else{
                SharedDataManager.sharedInstance.chosenCalendarDate = Utilities.stringFromDateNoTimezone(curDate as? NSDate, formatStr: genericTimeFormat)
            }
            if(SharedDataManager.sharedInstance.shouldGetUserInfo == false){
            self.refreshDaySchedule()
            }
            else{
            self.refreshUserSchedule()
            }
            
        } else if (tableView == shiftTable) {
            if (self.isFromRequest) {
                if ((self.delegate?.shiftDidSelect(NSShift.init()!) != nil)) {
                    
                }
            } else {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                SharedDataManager.sharedInstance.scheduleVC.showShiftDetail()
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (tableView == dayTable) {
            return dateArray.count
        } else if (tableView == shiftTable) {
            if(self.viewMode == EScheduleViewMode.ScheduleViewOpenShifts){
            return self.schedule.openShifts.count
            }
            else{
                //temp
              
            return   self.periods.count
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (tableView == dayTable) {
            return 46
        }
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        if (tableView == dayTable) {
            let dayCell = tableView.dequeueReusableCellWithIdentifier("DayTableCell", forIndexPath: indexPath) as! DayTableViewCell
        
            let dateObj = dateArray[indexPath.section] as! NSDate
            
            dayCell.dayNumLabel.text = String(calendar.daysInDate(dateObj))
            dayCell.dayWeekLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey(dateObj.dayNameOnCalendar(self.calendar).uppercaseString)
            
            if (indexPath.section == self.curIndexPath.section) {
                dayCell.setSelected(true, animated: true)
            }
            
            return dayCell
        } else if (tableView == shiftTable) {
            if (self.viewMode == EScheduleViewMode.ScheduleViewEveryone) {
                
                let shiftCell = tableView.dequeueReusableCellWithIdentifier("ShiftTableCell", forIndexPath: indexPath) as! ShiftTableViewCell
                
                //set shift               
                var period = self.periods.objectAtIndex(indexPath.section) as? NSSchedulePeriod
                
                let name = shiftCell.contentView.viewWithTag(2) as! UILabel
                let locationName = shiftCell.contentView.viewWithTag(3) as! UILabel
                let positionName = shiftCell.contentView.viewWithTag(4) as! UILabel
                let userImage = shiftCell.contentView.viewWithTag(1) as! UIImageView!
                let time = shiftCell.contentView.viewWithTag(5) as! UILabel!
                let colorView = shiftCell.contentView.viewWithTag(6) as UIView!
                
                name.text = period?.employeeName
                locationName.text = period?.locationName
                positionName.text = period?.positionName
                userImage.image = nil
                
                colorView.backgroundColor = Utilities.colorWithHexString(period!.color)
                userImage.sd_setImageWithURL(NSURL(string: period!.employeePhoto))
              
                time.text = "\(Utilities.convertPeriodHours((period?.startAt!)!))-\(Utilities.convertPeriodHours((period?.endAt)!))"
                //time.text = period?.startAt
                
                return shiftCell
            } else if (self.viewMode == EScheduleViewMode.ScheduleViewOpenShifts) {
                let shiftCell = tableView.dequeueReusableCellWithIdentifier("OpenShiftTableCell", forIndexPath: indexPath) as! OpenShiftTableViewCell
                let name = shiftCell.contentView.viewWithTag(1) as! UILabel
                let locationName = shiftCell.contentView.viewWithTag(2) as! UILabel
                let time = shiftCell.contentView.viewWithTag(3) as! UILabel!
                let colorView = shiftCell.contentView.viewWithTag(4) as UIView!
                
                var shift = NSSchedulePeriod()
                shift = shift!.initFromDictionary(self.schedule.openShifts.objectAtIndex(indexPath.section) as! NSDictionary)
                
                name.text = shift?.positionName
                locationName.text = shift?.locationName
                
                time.text = "\(Utilities.convertPeriodHours((shift?.startAt!)!))-\(Utilities.convertPeriodHours((shift?.endAt)!))"
               //  time.text = shift?.startAt
                colorView.backgroundColor = Utilities.colorWithHexString(shift!.color)
                   
                return shiftCell
            }
        }
        
        return cell
    }
    
    // Swipe to edit
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return self.viewMode == EScheduleViewMode.ScheduleViewOpenShifts
//    }
//    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let edit = UITableViewRowAction(style: .Normal, title: "PICK UP") { action, index in
//            print("Tap pick up")
//        }
//        edit.backgroundColor = MAIN_COLOR
//        return [edit]
//    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if (scrollView == shiftTable) {
            return
        }
        lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if (scrollView == shiftTable) {
            return
        }
        
        let numberOfDays = 10
        if (isGoPrevious == true) {
            print("Previous")
            
            dateArray.insertObjects(self.generateDays(dateArray[0] as! NSDate, isForward: false, numberOfDays: numberOfDays) as [AnyObject], atIndexes: NSMutableIndexSet(indexesInRange: NSRange(0...Int(numberOfDays-1))))
            
            self.curIndexPath = NSIndexPath.init(forRow:0, inSection: self.curIndexPath.section  + numberOfDays)

            self.dayTable.reloadData()
            self.dayTable.scrollToRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 7), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            self.dayTable.selectRowAtIndexPath(self.curIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)

        } else if (isGoNext == true) {
            print("Next")
            
            dateArray.addObjectsFromArray(self.generateDays(dateArray[dateArray.count-1] as! NSDate, isForward: true, numberOfDays: numberOfDays) as [AnyObject])
            
            self.dayTable.reloadData()
//            self.dayTable.scrollToRowAtIndexPath(self.curIndexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
            self.dayTable.selectRowAtIndexPath(self.curIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)

        }
        
        isGoNext = false
        isGoPrevious = false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView == shiftTable) {
            return
        }
        
        if (isGoPrevious == false && scrollView.contentOffset.y < 0) {
            isGoPrevious = true;
        }
        
        if (isGoNext == false && (scrollView.contentOffset.y + scrollView.bounds.size.height) >  CGFloat(self.dateArray.count * 50)) {
            isGoNext = true
        }
    }
    
    // MARK: - Tab Bar Changed
    func onMenuClicked(viewMode: EScheduleViewMode) {
        
        self.viewMode = viewMode
        
        switch viewMode {
        case .ScheduleViewMySchedule:
            self.myScheduleView.hidden = false
            self.shiftTable.hidden = true
            break
        case .ScheduleViewEveryone:
            self.myScheduleView.hidden = true
            self.shiftTable.hidden = false
            
            self.shiftTable.reloadData()
            break
        case .ScheduleViewOpenShifts:
            self.myScheduleView.hidden = true
            self.shiftTable.hidden = false
            
            self.shiftTable.reloadData()
            break;
        }
    }

    // MARK: - NSMyScheduleViewDelegate
    func shiftDidSelect(shiftObj: NSShift) {
        
        if ((self.delegate?.shiftDidSelect(shiftObj)) != nil) {
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //API Call
    
      func refreshDaySchedule(){
        self.filter = NSScheduleFilterDay()
      self.filter.startAt = SharedDataManager.sharedInstance.chosenCalendarDate
        self.schedule = NSScheduleDay()
        NSAPIClient.sharedInstance.getScheduleForDay(self.filter) { (nsData, error) -> Void in
            SVProgressHUD.dismiss()
            if(error != nil){
            Utilities.showMsg(NSLocalizedString("Failed getting day schedule", comment: "Failed getting day schedule"), delegate: self)
                print(error)
            }
            else{
         
            let scheduleDic = nsData as? NSDictionary
             self.schedule.startAt = scheduleDic?.valueForKey("startAt") as! String
             self.schedule.employees = Utilities.ValidateArray(scheduleDic?.valueForKey("employees") as! NSArray)
             self.schedule.openShifts = Utilities.ValidateArray(scheduleDic?.valueForKey("openShifts") as! NSArray)
            SharedDataManager.sharedInstance.daySchedule = self.schedule
              self.getPeriods()
                print(self.schedule.convertToDictionary())
            }
        }
        
    }
    
    func refreshUserSchedule(){
    //    SVProgressHUD.show()
        self.userFilter = NSUserScheduleFilter()
        self.userFilter!.scheduleViewType = SharedDataManager.sharedInstance.userScheduleView
        self.userFilter.startAt = SharedDataManager.sharedInstance.chosenCalendarDate
        NSAPIClient.sharedInstance.getScheduleForUser(self.userFilter!) { (nsData, error) -> Void in
            SVProgressHUD.dismiss()
            if(error == nil){
                self.userSchedule = NSScheduleUser()
                self.userSchedule = self.userSchedule.initWithDictionary((nsData as? NSDictionary)!)
                SharedDataManager.sharedInstance.userSchedule = self.userSchedule
                print( self.userSchedule?.convertToDictionary())
                self.drawShifts()
            }
            else{
                print("failed")
            }
        }

    }
    
    func getPeriods(){
        self.periods.removeAllObjects()
        let employees = Utilities.ValidateArray(self.schedule.employees)
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
                    self.periods.addObject(period!)
                  
                })
            }
        })
         self.shiftTable.reloadData()
    }

    //Pragma notification
    func refreshScheduleData (notification : NSNotification){

        self.userSchedule = SharedDataManager.sharedInstance.userSchedule
        self.getPeriods()
    }
    
    func refreshDayTable (notification : NSNotification){
      self.refreshDaySchedule()
    }
    
    func refreshUserDayTable(notification : NSNotification){
    self.refreshUserSchedule()
    }
}

