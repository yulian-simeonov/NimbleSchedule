//
//  WeekScheduleViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 10/28/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

protocol WeekScheduleViewControllerDelegate {
    func shiftDidSelect(shiftObj: NSShift)
}

class WeekScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate {

    var delegate: WeekScheduleViewControllerDelegate?
    
    @IBOutlet weak var shiftTable: UITableView!
    @IBOutlet weak var groupedTable: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    // Define
    private let weekShiftCellIdentifier = "WeekShiftTableCell"
    private let shiftCellIdentifier = "ShiftTableCell"
    private let openShiftCellIdentifier = "OpenShiftTableCell"

    var calendar = NSCalendar.currentCalendar()

    // View Mode
    var viewMode: EScheduleViewMode!
    
    var weekDates: NSArray!
    var weekPeriods = NSMutableArray()
    var curDate: NSDate!
    
    var weekSchedule : NSScheduleWeek!
    var weekFilter : NSScheduleFilterWeek!
     var userSchedule : NSScheduleUser!
    var userFilter : NSUserScheduleFilter!
    
    var shouldGetUserInfo : Bool = true
    var shiftsArray = SharedDataManager.sharedInstance.temporaryData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.shiftTable.registerNib(UINib.init(nibName: "WeekShiftTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: weekShiftCellIdentifier)
        self.groupedTable.registerNib(UINib.init(nibName: "ShiftTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: shiftCellIdentifier)
        self.groupedTable.registerNib(UINib.init(nibName: "OpenShiftTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: openShiftCellIdentifier)
        
        self.shouldGetUserInfo = SharedDataManager.sharedInstance.shouldGetUserInfo
        
        //add refresh notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshScheduleData:", name: "RefreshScheduleWeek", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTag:", name: "RefreshTag", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshUserSchedule:", name: "RefreshUserScheduleUser", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshDateTitle:", name: "RefreshTitle", object: nil)
        
        self.weekSchedule = NSScheduleWeek()
        self.weekPeriods = NSMutableArray()
        self.userSchedule = NSScheduleUser()
        
        // Initialize
        self.curDate = NSDate()
        self.updateCurrentWeek(Utilities.dateFromStringLocal(SharedDataManager.sharedInstance.chosenCalendarDate, isShortForm: true))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if(SharedDataManager.sharedInstance.shouldGetUserInfo == true){
        self.getUserSchedule()
        }
        else{
        self.getWeekSchedule()
        }
    }
    
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if ((self.delegate?.shiftDidSelect(NSShift.init()!) != nil)) {           
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.viewMode == EScheduleViewMode.ScheduleViewMySchedule) {
            return 1
        } else {
            return self.weekSchedule!.weekdays.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.viewMode == EScheduleViewMode.ScheduleViewMySchedule) {
             return self.weekDates.count
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
        if (self.viewMode == EScheduleViewMode.ScheduleViewMySchedule) {
            return 0
        } else {
            return 32
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (self.viewMode == EScheduleViewMode.ScheduleViewMySchedule) {
            return 0
        } else {
            return 10
        }
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
        if (self.viewMode == EScheduleViewMode.ScheduleViewMySchedule) {
            return 69
        } else
            if (self.viewMode == EScheduleViewMode.ScheduleViewEveryone ||
                self.viewMode == EScheduleViewMode.ScheduleViewOpenShifts) {
                    if (indexPath.row == 0) {
                        return 70+20
                    }
                    return 70
        } else {
            return 69
        }
    }
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return self.viewMode == EScheduleViewMode.ScheduleViewOpenShifts
//    }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let edit = UITableViewRowAction(style: .Normal, title: "PICK UP") { action, index in
//            print("Tap pick up")
//        }
//        edit.backgroundColor = UIColor.darkGrayColor()
//        return [edit]
//    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "test"
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init()
        
        if (self.viewMode == EScheduleViewMode.ScheduleViewMySchedule) {
            
            let shiftCell = tableView.dequeueReusableCellWithIdentifier(weekShiftCellIdentifier, forIndexPath: indexPath) as! WeekShiftTableViewCell       
            shiftCell.proceedContents(self.weekDates[indexPath.row] as! NSDate, shifts: self.userSchedule.filteredShifts.objectAtIndex(indexPath.row) as! NSMutableArray)
            shiftCell.shiftCollectionView.delegate = self
            shiftCell.shiftCollectionView.tag = indexPath.row
                      
            return shiftCell
            
        } else if (self.viewMode == EScheduleViewMode.ScheduleViewEveryone) {
            
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
    
    // MARK: - UICollectionViewDelegate ()
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if ((self.delegate?.shiftDidSelect(NSShift.init()!) != nil)) {
            
        }
    }
    
    // MARK: - UIButton Action
    
    @IBAction func onClickPrev(sender: AnyObject) {        
     self.weekChanged(-7)
    }
    
    @IBAction func onClickNext(sender: AnyObject) {
      self.weekChanged(7)
      
    }
    
    func weekChanged (daysToAdd : NSInteger){
        let date = Utilities.addDaysToDate(daysToAdd, date: Utilities.dateFromStringHours(SharedDataManager.sharedInstance.chosenCalendarDate, format: genericTimeFormat))
        SharedDataManager.sharedInstance.chosenCalendarDate = Utilities.stringFromDate(date, formatStr: genericTimeFormat)
        self.updateCurrentWeek(date)
                if(self.shouldGetUserInfo == true){
            self.getUserSchedule()
        }
        else{
            self.getWeekSchedule()
        }
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateScheduleTitle", object: nil)
    }
    
    // MARK: - Tab Bar Changed
    func onMenuClicked(viewMode: EScheduleViewMode) {
        
        self.viewMode = viewMode
        if (self.viewMode == EScheduleViewMode.ScheduleViewMySchedule) {
            self.shiftTable.hidden = false
            self.groupedTable.hidden = true
       //    self.shiftTable.reloadData()
        } else {
            self.shiftTable.hidden = true
            self.groupedTable.hidden = false
           // self.groupedTable.reloadData()
        }

    }
    
    func updateTitle() {
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "MMMM yyyy"
        
        SharedDataManager.sharedInstance.scheduleVC.title = dateformatter.stringFromDate(self.curDate)
    }
    

    func updateCurrentWeek(date: NSDate!) {
        
        let weekNum = Utilities.getWeek(Utilities.dateFromString(SharedDataManager.sharedInstance.chosenCalendarDate, isShortForm: true)!)
        let allDates = Utilities.daysInWeek(weekNum, date: Utilities.dateFromString(SharedDataManager.sharedInstance.chosenCalendarDate, isShortForm: true)!)
        
        let startDate = allDates[0] as! NSDate
        let endDate = allDates[allDates.count - 1] as! NSDate
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM.dd"
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "dd"
        
        self.curDate = Utilities.dateFromString(SharedDataManager.sharedInstance.chosenCalendarDate, isShortForm: true)
        
        var dateString = ""
        if (self.calendar.monthsInDate(startDate) == self.calendar.monthsInDate(endDate)) {
            dateString = "\(dateFormatter.stringFromDate(startDate)) - \(dateFormatter1.stringFromDate(endDate))".uppercaseString
        } else {
            dateString = "\(dateFormatter.stringFromDate(startDate)) - \(dateFormatter.stringFromDate(endDate))".uppercaseString
            
            // Month is moved. Need to update title with next month
        }
        self.updateTitle()

        self.dateLabel.text = "\(dateString) (Week \(weekNum))"
        
        self.weekDates = NSArray.init(array: allDates)
        //self.shiftTable.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getWeekSchedule(){
       self.weekSchedule = NSScheduleWeek()
        self.weekFilter = NSScheduleFilterWeek()
        self.weekFilter?.currentDate = SharedDataManager.sharedInstance.chosenCalendarDate
        self.weekFilter?.locationId = ""
        self.weekFilter?.positionId = ""
        // SVProgressHUD.show()
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
        self.userFilter?.scheduleViewType = SharedDataManager.sharedInstance.userScheduleView
        
        NSAPIClient.sharedInstance.getScheduleForUser(self.userFilter!) { (nsData, error) -> Void in
        if(error == nil){
            let dictionary = nsData as! NSDictionary
            self.userSchedule = self.userSchedule.initWithDictionary(dictionary)
                  let weekNumber = Utilities.getWeek(Utilities.dateFromString(Utilities.removeThumbnailSufix(self.userSchedule!.startAt, removeCount: -1), isShortForm: true)!)
                 self.userSchedule.getWeekDays(self.userSchedule, week: weekNumber)
               self.userSchedule.filterShifts(self.userSchedule)
               self.shiftTable.reloadData()
            
        }
        else{
        Utilities.showMsg(NSLocalizedString("Failed getting schedule", comment: "Failed getting schedule"), delegate: self)
        }
        
        }
    }
    
    
    func getPeriods(){
        self.weekPeriods = self.weekSchedule.getPeriods(self.weekSchedule)
        self.weekSchedule.filterShifts(self.weekSchedule, weekPeriods: self.weekPeriods)
        self.groupedTable.reloadData()
    }
    
    
   //Pragma notification
    func refreshScheduleData (notification : NSNotification){
    self.getWeekSchedule()
        //print(self.weekSchedule)
    }
    
    func refreshTag (notification : NSNotification){
        self.shouldGetUserInfo = SharedDataManager.sharedInstance.shouldGetUserInfo
    }
    
    func refreshUserSchedule (notification : NSNotification){
        self.getUserSchedule()
        self.updateCurrentWeek(Utilities.dateFromString(SharedDataManager.sharedInstance.chosenCalendarDate, isShortForm: true))
    }
    
    func refreshDateTitle (notification : NSNotification){
        self.updateCurrentWeek(Utilities.dateFromStringHours(SharedDataManager.sharedInstance.chosenCalendarDate, format: genericTimeFormat))
    }
    //Pragma api calls


}