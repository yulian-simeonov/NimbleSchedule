//
//  MonthScheduleViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 10/28/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

protocol MonthScheduleViewControllerDelegate {
    func shiftDidSelect(shiftObj: NSShift)
}

class MonthScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, NSMyScheduleViewDelegate {
    
    var delegate: MonthScheduleViewControllerDelegate?
    
    private let cellIdentifier = "CallendarCollectionCell"
     private let openShiftCellIdentifier = "OpenShiftTableCell"
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0.0, right: 0.0)
    private let shiftCellIdentifier = "ShiftTableCell"

    private let cellWid:CGFloat = CGFloat(SCRN_WIDTH/7)
    private var cellHei:CGFloat = 120
    
    var numberOfSections = 5
    
    var displayedDate: NSDate!
    var calendar = NSCalendar.currentCalendar()
    var dayCount: Int = 0
    var shiftDayCount: Int = 0
    var viewMode: EScheduleViewMode!
    var todayDay: Int = 0
    var selDay: Int = 0
    
    var isShiftTableShown: Bool = false
    var isMyScheduleShown: Bool = false
    
    var userSchedule : NSScheduleUser!
    var weekSchedule : NSScheduleWeek!
    var userFilter : NSUserScheduleFilter!
    var weekFilter : NSScheduleFilterWeek!
    var periods : NSMutableArray!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var monthShiftTable: UITableView!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var headerHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var myScheduleView: NSMyScheduleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.displayedDate = NSDate()
        self.todayDay = Utilities.getDay(NSDate())
        self.selDay = Utilities.getDay(self.displayedDate)

        self.calendar = NSCalendar.autoupdatingCurrentCalendar()
        self.calendar.locale = NSLocale.currentLocale()
        
        self.monthShiftTable.registerNib(UINib.init(nibName: "ShiftTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: shiftCellIdentifier)
        self.monthShiftTable.registerNib(UINib.init(nibName: "OpenShiftTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: openShiftCellIdentifier)
        
        
        self.weekSchedule = NSScheduleWeek()
        self.userSchedule = NSScheduleUser()
        
        self.navigateView(false, animated: false, targetView: self.monthShiftTable)
        self.navigateView(false, animated: false, targetView: self.myScheduleView)
             self.showWeekDaysInHeader(Utilities.dateFromStringHours(SharedDataManager.sharedInstance.chosenCalendarDate, format: genericTimeFormat), isShow: false, animated: true)
        
        //Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUserSchedule:", name: "RefreshUserScheduleUser", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateMonthSchedule:", name: "RefreshMonthTable", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getSchedules()
    }
    

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // Calculate Shift
        let firstOfTheMonth = self.calendar.firstDayOfTheMonthUsingReferenceDate(self.displayedDate)
        shiftDayCount = self.calendar.weekdayInDate(firstOfTheMonth) - 1
        
        if (shiftDayCount < 0) {
            shiftDayCount += 7
        }
        
        
        // Calculate range
        let range = self.calendar.rangeOfUnit(.Day, inUnit: NSCalendarUnit.Month, forDate: self.displayedDate)
        dayCount = Int(self.calendar.daysPerMonthUsingReferenceDate(self.displayedDate))
        
        if (Int(dayCount + shiftDayCount) > 35) {
            numberOfSections = 6
        } else {
            numberOfSections = 5
        }
        
        cellHei = CGFloat(self.calendarCollectionView.bounds.height / CGFloat(numberOfSections))
        
        self.calendarCollectionView.reloadData()
        self.drawHeader(false)
        
       /* let shift = NSShift.init()
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
        */
        self.myScheduleView.drawLine()
        self.myScheduleView.delegate = self
        self.myScheduleView.backgroundColor = UIColor.whiteColor()
        //self.myScheduleView.addShift(shift!)
        //self.myScheduleView.addShift(shift1!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility Functions
    func displayedMonthStartDate() -> NSDate {
        let comp = self.calendar.components([.Month, .Year], fromDate: self.displayedDate)
        comp.day = 1
        return self.calendar.dateFromComponents(comp)!
    }
    
    func showWeekDaysInHeader(referenceDate: NSDate, isShow: Bool, animated: Bool) {
        if (isShow) {
            self.displayedDate = referenceDate
            self.drawHeader(isShow)
        }
        
        headerHeiConstraint.constant = isShow ? 92 : 32
        if (animated) {
            UIView .animateWithDuration(0.5, animations: { () -> Void in
                self.headerView.layoutIfNeeded()
            }, completion: { (completed) -> Void in
                self.myScheduleView.updateContainerSize()
            })
        }
    }
    
    func drawHeader(isShowWeekDays: Bool) {
        self.headerView.subviews.forEach({ $0.removeFromSuperview() })
        let dayArray = ["S", "M", "T", "W", "TH", "F", "S"]
        
        let weekNum = self.calendar.weekOfYearInDate(self.displayedDate)
        let allDates = self.calendar.allDatesInWeek(Int32(weekNum))

        for i in 0...6 {
            let label = UILabel.init(frame: CGRectMake(CGFloat(i)*cellWid, 0, cellWid, 32))
            label.font = Utilities.fontWithSize(10)
            label.textAlignment = .Center
            label.text = dayArray[i]
            label.backgroundColor = UIColor.clearColor()
            label.textColor = GRAY_COLOR_3
            
            if (isShowWeekDays) {
                let dateObj = allDates[i]
                let dayNum = Utilities.getDay(dateObj as! NSDate)
                let dayLabel = UILabel.init(frame: CGRectMake((cellWid - 27) / 2 + CGFloat(i)*cellWid, 48, 27, 27))
                dayLabel.font = Utilities.fontWithSize(13)
                dayLabel.textAlignment = .Center
                dayLabel.text = "\(dayNum)"
                dayLabel.layer.cornerRadius = 13.5
                dayLabel.layer.masksToBounds = true
                
                if (dayNum == selDay) {
                    dayLabel.textColor = UIColor.whiteColor()
                    dayLabel.backgroundColor = GRAY_COLOR_3
                } else {
                    dayLabel.textColor = GRAY_COLOR_3
                    dayLabel.backgroundColor = UIColor.clearColor()
                }
                self.headerView.addSubview(dayLabel)
            }
            
            self.headerView.addSubview(label)
        }
    }
    
    func navigateView(isShow: Bool, animated: Bool, targetView: UIView) {
        if (isShow) {
            targetView.transform = CGAffineTransformMakeTranslation(SCRN_WIDTH, 0)
        } else {
            targetView.transform = CGAffineTransformMakeTranslation(0, 0)
        }
        if (animated) {
            UIView .animateWithDuration(0.3, animations: { () -> Void in
                targetView.transform = isShow ? CGAffineTransformMakeTranslation(0, 0) : CGAffineTransformMakeTranslation(SCRN_WIDTH, 0)
            }) { (completed) -> Void in
                
            }
        } else {
            targetView.transform = isShow ? CGAffineTransformMakeTranslation(0, 0) : CGAffineTransformMakeTranslation(SCRN_WIDTH, 0)
        }
        if (targetView == self.monthShiftTable) {
            isShiftTableShown = isShow
        } else {
            isMyScheduleShown = isShow
        }
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//            if (indexPath.item == 6) {
//                return CGSizeMake(SCRN_WIDTH - cellWid*7, cellHei)
//            }
            return CGSizeMake(cellWid, cellHei)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let index = indexPath.section * 7 + indexPath.item
        let day = Int(index-shiftDayCount) + 1
        
        if (index >= shiftDayCount &&  day <= dayCount) {
            return true
        } else {
            return false
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if (self.viewMode == EScheduleViewMode.ScheduleViewMySchedule) {
            self.navigateView(true, animated: true, targetView: self.myScheduleView)
        } else {
            self.navigateView(true, animated: true, targetView: self.monthShiftTable)
        }
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MonthCalendarCollectionViewCell
        
        let firstOfTheMonth = self.calendar.firstDayOfTheMonthUsingReferenceDate(self.displayedDate)
        self.displayedDate = self.calendar.dateByAddingDays(UInt(cell.dayNumber-1), toDate: firstOfTheMonth)
        self.selDay = Utilities.getDay(self.displayedDate)
        SharedDataManager.sharedInstance.chosenCalendarDate = Utilities.stringFromDate(self.displayedDate, formatStr: genericTimeFormat)
        self.getSchedules()
        self.showWeekDaysInHeader(self.displayedDate, isShow: true, animated: true)
        NSNotificationCenter.defaultCenter().postNotificationName("RefreshTitle", object: nil)
        
        if (self.viewMode == EScheduleViewMode.ScheduleViewMySchedule) {
            self.myScheduleView.updateContainerSize()
        }
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! MonthCalendarCollectionViewCell
        // Configure the cell
        
//        if (indexPath.item < 6) {
//            cell.rightBorder.hidden = false
//        } else {
            cell.rightBorder.hidden = true
//        }
        
        if (indexPath.section < numberOfSections - 1) {
            cell.btmBorder.hidden = false
        } else {
            cell.btmBorder.hidden = true
        }
        
        let index = indexPath.section * 7 + indexPath.item
        let day = Int(index-shiftDayCount) + 1
        
        if (index >= shiftDayCount &&  day <= dayCount) {
            cell.dayLabel.text = "\(day)"
        } else {
            cell.dayLabel.text = ""
        }
        cell.dayNumber = day
        
        if (day == self.todayDay) {
            cell.makeTodayCell()
        } else if (day == self.selDay) {
            cell.makeCellSelected()
        } else {
            cell.makeNormalCell()
        }
        
        return cell
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if ((self.delegate?.shiftDidSelect(NSShift.init()!) != nil)) {
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(self.weekSchedule?.weekdays.count > 0){
        return 7
        }
        else{
        return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.viewMode == EScheduleViewMode.ScheduleViewMySchedule) {
            return 0
        } else {
            //open shifts
            if(self.viewMode ==  EScheduleViewMode.ScheduleViewOpenShifts){
                if(self.weekSchedule != nil  && self.weekSchedule!.weekdays.count > 0){
                    print(self.weekSchedule!.weekdays.count)
                    
                    let dictionary = self.weekSchedule!.weekdays.objectAtIndex(section) as! NSDictionary
                    var weekDay = NSWeekDay()
                    weekDay = weekDay?.initWithDictionary(dictionary)
                    return (weekDay?.openShifts.count)!
                }
                else{
                    return 0
                }
                
            }
            else{
                if(self.weekSchedule != nil  && self.weekSchedule!.weekdays.count > 0){
                    let descriptor: NSSortDescriptor = NSSortDescriptor(key: "index", ascending: true)
                    let sortedResults: NSArray = self.weekSchedule!.weekdays.sortedArrayUsingDescriptors([descriptor])
                    self.weekSchedule.weekdays = sortedResults.mutableCopy() as! NSMutableArray
                    let dictionary = self.weekSchedule!.weekdays.objectAtIndex(section) as! NSDictionary
                    var weekDay = NSWeekDay()
                    weekDay = weekDay?.initWithDictionary(dictionary)
                    return (weekDay?.shifts.count)!
                }
                else{
                    
                    return 0
                }
            }
        }

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 32
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 32))
        headerView.backgroundColor = GRAY_COLOR_5
        headerView.layer.borderColor = GRAY_COLOR_6.CGColor
        headerView.layer.borderWidth = 0.6
        
        let descLabel = UILabel.init(frame: CGRectMake(15, 0, 150, 32))
        
        let dateArray = Utilities.ValidateMutableArray(self.weekSchedule.weekdays)
        if(dateArray.count > section){
            let dic = weekSchedule.weekdays.objectAtIndex(section) as! NSDictionary
            let date = Utilities.dateFromString(Utilities.removeThumbnailSufix((dic.valueForKey("day") as? String)!, removeCount: -1), isShortForm: true)
            let dateFormatted = Utilities.stringFromDate(date, formatStr: "MMM.dd")
            let dateSufix = Utilities.setDayName(section)
            descLabel.text = "\(dateFormatted), \(dateSufix)"
            
        }
        else{
            descLabel.text=""
        }
        descLabel.font = Utilities.fontWithSize(13)
        descLabel.textColor = GRAY_COLOR_3
        descLabel.backgroundColor = UIColor.clearColor()
        headerView .addSubview(descLabel)
        
        return headerView
    }
    

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            return 70+20
        }
        return 70
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let newView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        newView.backgroundColor = UIColor.whiteColor()
        return newView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init()
        
       if (self.viewMode == EScheduleViewMode.ScheduleViewEveryone) {
            
            let shiftCell = tableView.dequeueReusableCellWithIdentifier(shiftCellIdentifier, forIndexPath: indexPath) as! ShiftTableViewCell
            
            let name = shiftCell.contentView.viewWithTag(2) as! UILabel
            let locationName = shiftCell.contentView.viewWithTag(3) as! UILabel
            let positionName = shiftCell.contentView.viewWithTag(4) as! UILabel
            let userImage = shiftCell.contentView.viewWithTag(1) as! UIImageView!
            let time = shiftCell.contentView.viewWithTag(5) as! UILabel!
            let colorView = shiftCell.contentView.viewWithTag(6) as UIView!
            
            
            
            if(self.weekSchedule?.weekdays.count >= indexPath.section){
                let weekDayDic = self.weekSchedule?.weekdays.objectAtIndex(indexPath.section) as! NSDictionary
                var weekDay = NSWeekDay()
                weekDay = weekDay?.initWithDictionary(weekDayDic)
                
                let period = weekDay?.shifts.objectAtIndex(indexPath.row) as! NSSchedulePeriod
                
                name.text = period.employeeName
                locationName.text = period.locationName
                positionName.text = period.positionName
                
                time.text = "\(Utilities.convertPeriodHours((period.startAt!)))-\(Utilities.convertPeriodHours((period.endAt)!))"
                // time.text = period.startAt
                colorView.backgroundColor = Utilities.colorWithHexString(period.color)
                
                userImage.image = nil
                userImage.sd_setImageWithURL(NSURL.init(string:period.employeePhoto))
                
            }
            
            
            
            
            
            return shiftCell
        } else if (self.viewMode == EScheduleViewMode.ScheduleViewOpenShifts) {
            
            let shiftCell = tableView.dequeueReusableCellWithIdentifier(openShiftCellIdentifier, forIndexPath: indexPath) as! OpenShiftTableViewCell
            
            let name = shiftCell.contentView.viewWithTag(1) as! UILabel
            let locationName = shiftCell.contentView.viewWithTag(2) as! UILabel
            let time = shiftCell.contentView.viewWithTag(3) as! UILabel!
            let colorView = shiftCell.contentView.viewWithTag(4) as UIView!
            
            
            
            let weekDayDic = self.weekSchedule?.weekdays.objectAtIndex(indexPath.section) as! NSDictionary
            var weekDay = NSWeekDay()
            weekDay = weekDay?.initWithDictionary(weekDayDic)
            
            let period = weekDay?.openShifts.objectAtIndex(indexPath.row) as! NSSchedulePeriod
            
            name.text = period.locationName
            locationName.text = period.positionName
            time.text = "\(Utilities.convertPeriodHours((period.startAt!)))-\(Utilities.convertPeriodHours((period.endAt)!))"
            //time.text = period.startAt
            colorView.backgroundColor = Utilities.colorWithHexString(period.color)
            
            return shiftCell
        }
        
        return cell
        
        
    }
    
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    // MARK: - Tab Bar Changed
    func onMenuClicked(viewMode: EScheduleViewMode) {
        
        if (self.viewMode != viewMode) {
            self.viewMode = viewMode
        }
        
        if (isShiftTableShown) {
            self.navigateView(false, animated: true, targetView: self.monthShiftTable)
            self.showWeekDaysInHeader(Utilities.dateFromStringHours(SharedDataManager.sharedInstance.chosenCalendarDate, format: genericTimeFormat), isShow: false, animated: true)
        }
        
        if (isMyScheduleShown) {
            self.navigateView(false, animated: true, targetView: self.myScheduleView)
            self.showWeekDaysInHeader(Utilities.dateFromStringHours(SharedDataManager.sharedInstance.chosenCalendarDate, format: genericTimeFormat), isShow: false, animated: true)

        }
        
        self.calendarCollectionView.reloadData()
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
 //MARK API
    func getSchedules(){
        
        if (SharedDataManager.sharedInstance.shouldGetUserInfo == true){
            self.getUserSchedule()
        }
        else{
            self.getWeekSchedule()
        }
    }
    
    func getPeriods(){
    self.periods = self.weekSchedule.getPeriods(self.weekSchedule)
    self.weekSchedule.filterShifts(self.weekSchedule, weekPeriods: self.periods)
         self.monthShiftTable.reloadData()
    }
    
    func getWeekSchedule(){
        self.weekSchedule = NSScheduleWeek()
        self.weekFilter = NSScheduleFilterWeek()
        self.weekFilter?.currentDate = SharedDataManager.sharedInstance.chosenCalendarDate
        self.weekFilter?.locationId = ""
        self.weekFilter?.positionId = ""
        // SVProgressHUD.show()
         self.showWeekDaysInHeader(Utilities.dateFromStringHours(SharedDataManager.sharedInstance.chosenCalendarDate, format: genericTimeFormat), isShow: true, animated: true)

        NSAPIClient.sharedInstance.getScheduleForWeek(self.weekFilter!) { (nsData, error) -> Void in
            
            if(error == nil){
                SVProgressHUD.dismiss()
                let schedule = nsData as! NSDictionary
                self.weekSchedule!.days = (schedule.objectForKey("days") as? NSDictionary)!
                self.weekSchedule!.employees = (schedule.objectForKey("employees") as? NSArray)!
                self.weekSchedule!.openShifts = (schedule.objectForKey("openShifts") as? NSArray)!
                SharedDataManager.sharedInstance.weekSchedule = self.weekSchedule
                //     SharedDataManager.sharedInstance.weakScheduleFilter = self.weekFilter
                let weekNumber = Utilities.getWeek(Utilities.dateFromString(self.weekFilter!.currentDate, isShortForm: true)!)
                self.weekSchedule = self.weekSchedule?.initWithDictionary(schedule)
                self.weekSchedule?.returnDays(self.weekSchedule!)
                print(schedule)
                
                self.getPeriods()
                
            }
            else{
                SVProgressHUD.dismiss()
                Utilities.showMsg(NSLocalizedString("Failed getting week schedule", comment: "Failed getting week schedule"), delegate: self)
            }
        }
       
    }
    
    func getUserSchedule(){
        self.userFilter = NSUserScheduleFilter()
        self.userSchedule = NSScheduleUser()
        self.userFilter?.startAt = SharedDataManager.sharedInstance.chosenCalendarDate
        self.userFilter?.scheduleViewType = "Day"
     self.showWeekDaysInHeader(Utilities.dateFromStringHours(SharedDataManager.sharedInstance.chosenCalendarDate, format: genericTimeFormat), isShow: true, animated: true)

        NSAPIClient.sharedInstance.getScheduleForUser(self.userFilter!) { (nsData, error) -> Void in
            if(error == nil){
                let dictionary = nsData as! NSDictionary
                self.userSchedule = self.userSchedule.initWithDictionary(dictionary)
                let weekNumber = Utilities.getWeek(Utilities.dateFromString(Utilities.removeThumbnailSufix(self.userSchedule!.startAt, removeCount: -1), isShortForm: true)!)
                self.userSchedule.getWeekDays(self.userSchedule, week: weekNumber)
                self.userSchedule.filterShifts(self.userSchedule)
                self.drawShifts()
                
            }
            else{
                Utilities.showMsg(NSLocalizedString("Failed getting schedule", comment: "Failed getting schedule"), delegate: self)
            }
            
        }
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
    
    //NSNotification
    func updateUserSchedule(notification : NSNotification){
        self.getUserSchedule()
    }
    
    func updateMonthSchedule(notification : NSNotification){
       self.getWeekSchedule()
    }

}
