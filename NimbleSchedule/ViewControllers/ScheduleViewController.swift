//
//  ScheduleViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 10/13/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

protocol ScheduleViewControllerDelegate {
    func shiftDidSelect(shiftObj: NSShift)
}

class ScheduleViewController: UIViewController, UIScrollViewDelegate, JTCalendarDelegate, DayScheduleViewControllerDelegate, WeekScheduleViewControllerDelegate, MonthScheduleViewControllerDelegate {

    var requestDelegate: ScheduleViewControllerDelegate?
    
    @IBOutlet weak var tabHairlineView: UIView!
    @IBOutlet weak var calendarSegment: UISegmentedControl!
    @IBOutlet weak var tabScrollView: UIScrollView!
    
    @IBOutlet weak var tabbarView: UIView!
    @IBOutlet weak var segmentView: UIView!
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var hamburgerButton: UIButton!
    
    @IBOutlet weak var calendarMenuView: JTCalendarMenuView!
    @IBOutlet weak var calendarContentView: JTHorizontalCalendarView!
    
    @IBOutlet weak var calendarViewHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabbarHeiConstraint: NSLayoutConstraint!
    
    // Tabbar Buttons
    @IBOutlet weak var myScheduleTabButton: UIButton!
    @IBOutlet weak var everyoneTabButton: UIButton!
    @IBOutlet weak var openShiftsTabButton: UIButton!
    
    var calendarManager: JTCalendarManager!
    
    var dayViewController: DayScheduleViewController!
    var weekViewController: WeekScheduleViewController!
    var monthViewController: MonthScheduleViewController!
    
    var scheduleViewMode: EScheduleViewMode?
    var scheduleCalendarMode: EScheduleCalendarMode?
    
    var selectedDate: NSDate!
    
    var isCalendarShown: Bool = false
    
    var segmentNumber : NSInteger = 0
    var tabNumber : NSInteger = 0
   /* var weekFilter = NSScheduleFilterWeek()
    var scheduleWeek = NSScheduleWeek()
    var dayFilter = NSScheduleFilterDay()
    var scheduleDay = NSScheduleDay()
    var userFilter = NSUserScheduleFilter()
   // var scheduleUser = NSScheduleUser()
*/
    
    var shouldGetUserInfo : Bool = true
    var userScheduleViewMode : String = "Day"
    
    // If it is called from Request View
    var isFromRequest: Bool = false
    var isFromPickOpenShiftRequest: Bool = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
               self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()
        
        SharedDataManager.sharedInstance.scheduleVC = self;
        
        // Initialize
        scheduleViewMode = EScheduleViewMode.ScheduleViewMySchedule
        scheduleCalendarMode = EScheduleCalendarMode.ScheduleCalendarDay
        
        //Initialize filters
        SharedDataManager.sharedInstance.chosenCalendarDate = Utilities.stringFromDateNoTimezone(NSDate(), formatStr: genericTimeFormat)
        SharedDataManager.sharedInstance.shouldGetUserInfo = true
     //   self.scheduleUser = NSScheduleUser()
       // SharedDataManager.sharedInstance.dayScheduleFilter = self.dayFilter
       // SharedDataManager.sharedInstance.weakScheduleFilter = self.weekFilter
   
        // Update UI
        self.buildTabbarScrollView()
        
        if (isFromRequest || isFromPickOpenShiftRequest) {
            tabbarHeiConstraint.constant = 0
            tabbarView.hidden = true
            
            backButton.hidden = false
            titleButton.hidden = true
            hamburgerButton.hidden = true
// self.updateScheduleContent(EScheduleCalendarMode.ScheduleCalendarWeek, viewMode: EScheduleViewMode.ScheduleViewMySchedule)
        } else {
            backButton.hidden = true
            titleButton.hidden = false
            hamburgerButton.hidden = false
            
            self.tabbarView.layer.borderColor = GRAY_COLOR_5.CGColor
            self.tabbarView.layer.borderWidth = 0.7
            self.updateTabbarButtons()
            
            if(self.shouldGetUserInfo == false){
            self.getSchedule()
            }
            else{
                self.getUserSchedule()
            }
            
            self.updateScheduleContent(EScheduleCalendarMode.ScheduleCalendarDay, viewMode: EScheduleViewMode.ScheduleViewMySchedule)
        }
        
        
        // Disable swipe to SideMenu
        self.sidePanelController?.allowLeftSwipe = false
        
        // Init Calendar
        self.initCalendar()
        
        //add observers for notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshFilterDay:", name:"RefreshFilterDay" , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTitleForDay:", name: "UpdateScheduleTitle", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (isFromRequest) {
            self.updateScheduleContent(EScheduleCalendarMode.ScheduleCalendarWeek, viewMode: EScheduleViewMode.ScheduleViewMySchedule)
        } else if (isFromPickOpenShiftRequest) {
            self.updateScheduleContent(EScheduleCalendarMode.ScheduleCalendarWeek, viewMode: EScheduleViewMode.ScheduleViewOpenShifts)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Localize
    func localizeContent() {
    
        self.calendarSegment.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("Day"), forSegmentAtIndex: 0)
        self.calendarSegment.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("Week"), forSegmentAtIndex: 1)
        self.calendarSegment.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("Month"), forSegmentAtIndex: 2)
        
        myScheduleTabButton.setImage(LocalizeHelper.sharedInstance.localizedImageForKey("button-tab-myschedule"), forState: .Normal)
        everyoneTabButton.setImage(LocalizeHelper.sharedInstance.localizedImageForKey("button-tab-everyone"), forState: .Normal)
        openShiftsTabButton.setImage(LocalizeHelper.sharedInstance.localizedImageForKey("button-tab-openshifts"), forState: .Normal)
    }
    
    func updateTitleWithSelectedDate() {
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "MMMM yyyy"
        titleButton.setTitle(dateFormatter.stringFromDate(selectedDate), forState: .Normal)
    }
    
    // MARK: - Calendar Function
    func initCalendar() {
        
        calendarManager = JTCalendarManager()
        calendarManager.delegate = self
        calendarManager.settings.weekDayFormat = .Single
        calendarManager.menuView = calendarMenuView
        calendarManager.contentView = calendarContentView
        calendarManager.setDate(Utilities.dateFromString(SharedDataManager.sharedInstance.chosenCalendarDate, isShortForm: true))
        
        selectedDate = Utilities.dateFromString(SharedDataManager.sharedInstance.chosenCalendarDate, isShortForm: true)
        self.updateTitleWithSelectedDate()
        
        self.showCalendar(false, animated: false)
    }
    
    func showCalendar(isShow: Bool, animated: Bool) {
        
        calendarViewHeiConstraint.constant = isShow ? 300 : 0
        isCalendarShown = isShow
        if (isShow) {
            titleButton.setImage(UIImage.init(named: "arrow-up"), forState: .Normal)
        } else {
            titleButton.setImage(UIImage.init(named: "arrow-down"), forState: .Normal)
        }
        if (animated) {
            UIView .animateWithDuration(0.5) { () -> Void in
                self.calendarContentView.layoutIfNeeded()
            }
        }
    }
    
    func hideCalendar() {
        calendarViewHeiConstraint.constant =  0
        isCalendarShown = false
        
              titleButton.setImage(UIImage.init(named: "arrow-down"), forState: .Normal)
        
            UIView .animateWithDuration(0.5) { () -> Void in
                self.calendarContentView.layoutIfNeeded()
        }
    }
    
    // MARK: - Page Navigation
    func showShiftDetail() {
        
        self.performSegueWithIdentifier(kShowShiftDetailVC, sender: self)
    }
    
    func showShiftFilter() {
        
        self.performSegueWithIdentifier(kShowShiftFilterVC, sender: self)
    }
    
    // MARK: - UIButtonAction
    
    @IBAction func onClickTitle(sender: AnyObject) {
        
        self.showCalendar(!isCalendarShown, animated: true)
    }
    
    @IBAction func onClickHamburger(sender: AnyObject) {
        
        self.sidePanelController?.showLeftPanelAnimated(true)
    }
    
    // MARK: - Segment Change
    
    @IBAction func onSegmentChange(sender: AnyObject) {
        self.segmentNumber = self.calendarSegment.selectedSegmentIndex
        SharedDataManager.sharedInstance.segmentIndex = self.calendarSegment.selectedSegmentIndex
        print(self.segmentNumber)
        if(SharedDataManager.sharedInstance.shouldGetUserInfo == false){
        self.getSchedule()
        }
        else{
        self.getUserSchedule()
        }
        self.updateScheduleContent(EScheduleCalendarMode(rawValue: self.calendarSegment.selectedSegmentIndex)!, viewMode: self.scheduleViewMode!)
    }
    
    @IBAction func onClickTabbar(sender: AnyObject) {
        
        self.updateScheduleContent(self.scheduleCalendarMode!, viewMode:EScheduleViewMode(rawValue:sender.tag)!)
        self.tabNumber = sender.tag
        print(self.tabNumber)
       
      
        if(self.tabNumber > 0){
            SharedDataManager.sharedInstance.shouldGetUserInfo = false
         self.getSchedule()
        }
        else{
            SharedDataManager.sharedInstance.shouldGetUserInfo = true
        self.getUserSchedule()
        }
          NSNotificationCenter.defaultCenter().postNotificationName("RefreshTag", object: nil)
        self.updateTabbarButtons()
    }
    
    @IBAction func onClickBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: - Tabbar Utility Functions
    func updateTabbarButtons() {
        
        for button in tabbarView.subviews {
            (button as! UIButton).layer.borderColor = GRAY_COLOR_4.CGColor
            (button as! UIButton).layer.borderWidth = 0.4
            if ((button as! UIButton).tag == scheduleViewMode?.rawValue) {
                (button as! UIButton).backgroundColor = UIColor.whiteColor()
                (button as! UIButton).selected = true
            } else {
                (button as! UIButton).backgroundColor = GRAY_COLOR_5
                (button as! UIButton).selected = false
            }
        }
    }
    
    func moveHairlineToIndex(index: Int) {
        
        UIView.animateWithDuration(0.25) { () -> Void in
            let xPos = self.tabHairlineView.bounds.size.width * CGFloat(index)
            let transform = CGAffineTransformMakeTranslation(xPos, 0)
            self.tabHairlineView.transform = transform
        }
    }
    
    func buildTabbarScrollView() {
        
        let width = SCRN_WIDTH
        let height = SCRN_HEIGHT - self.segmentView.bounds.size.height - self.tabbarView.bounds.size.height - 64
        
        self.tabScrollView.contentSize = CGSizeMake(width * 3, height)
        self.tabScrollView.frame = CGRectMake(0, 45, width, height)
        
        self.dayViewController = SharedDataManager.sharedInstance.scheduleStoryboard.instantiateViewControllerWithIdentifier(kIdentifierDayScheduleView) as! DayScheduleViewController
        self.dayViewController.isFromRequest = self.isFromRequest || self.isFromPickOpenShiftRequest
        self.dayViewController.delegate = self
        self.dayViewController.view.frame = CGRectMake(0, 0, width, height)
        
        self.weekViewController = SharedDataManager.sharedInstance.scheduleStoryboard.instantiateViewControllerWithIdentifier(kIdentifierWeekScheduleView) as! WeekScheduleViewController
        self.weekViewController.delegate = self
        self.weekViewController.view.frame = CGRectMake(width, 0, width, height)
        
        self.monthViewController = SharedDataManager.sharedInstance.scheduleStoryboard.instantiateViewControllerWithIdentifier(kIdentifierMonthScheduleView) as! MonthScheduleViewController
        self.monthViewController.delegate = self
        self.monthViewController.view.frame = CGRectMake(width*2, 0, width, height)
        
        self.addChildViewController(self.dayViewController)
        self.addChildViewController(self.weekViewController)
        self.addChildViewController(self.monthViewController)
        
        self.tabScrollView.addSubview(self.dayViewController.view)
        self.tabScrollView.addSubview(self.weekViewController.view)
        self.tabScrollView.addSubview(self.monthViewController.view)
    }
    
    func updateScheduleContent(calendarMode: EScheduleCalendarMode, viewMode: EScheduleViewMode) {
        
        // Scroll to another view controller (Day, Week, Month)
        if (self.scheduleCalendarMode != calendarMode) {
            self.tabScrollView.setContentOffset(CGPointMake(self.tabScrollView.bounds.size.width * CGFloat(calendarMode.rawValue), 0), animated: true)
            self.scheduleCalendarMode = calendarMode
            self.calendarSegment.selectedSegmentIndex = calendarMode.rawValue
        
        }
        
        // Update content (My Schedule, Everyone, OpenShifts)
        if (self.scheduleViewMode != viewMode) {
//            self.moveHairlineToIndex(viewMode.rawValue)
            self.scheduleViewMode = viewMode
        }
        
        switch calendarMode {
        case .ScheduleCalendarDay:
            self.dayViewController.onMenuClicked(viewMode)
            break
        case .ScheduleCalendarWeek:
            self.weekViewController.onMenuClicked(viewMode)
            
            break
        case .ScheduleCalendarMonth:
            self.monthViewController.onMenuClicked(viewMode)
           
            break
        }

    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        self.calendarSegment.selectedSegmentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        self.scheduleCalendarMode = EScheduleCalendarMode(rawValue: self.calendarSegment.selectedSegmentIndex)!
    }
    
    // MARK: - CalendarManagerDelegate
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        dayView.hidden = false
        
        let jtDayView = dayView as! JTCalendarDayView
        // Other Month
        if (jtDayView.isFromAnotherMonth) {
            jtDayView.hidden = true
        }
        // Today
        else if (calendarManager.dateHelper.date(Utilities.dateFromString(SharedDataManager.sharedInstance.chosenCalendarDate, isShortForm: true), isTheSameDayThan: jtDayView.date)) {
            jtDayView.circleView.hidden = false
            jtDayView.circleView.backgroundColor = MAIN_COLOR
            jtDayView.dotView.backgroundColor = UIColor.whiteColor()
            jtDayView.textLabel.textColor = UIColor.whiteColor()
        }
        // Selected Date
        else if (
            selectedDate != nil &&
            calendarManager.dateHelper.date(selectedDate, isTheSameDayThan: jtDayView.date)) {
                
            jtDayView.circleView.hidden = false
            jtDayView.circleView.backgroundColor = UIColor.whiteColor()
            jtDayView.dotView.backgroundColor = UIColor.whiteColor()
            jtDayView.textLabel.textColor = NAV_COLOR
        }
        // Another day of the current month
        else  {
            jtDayView.circleView.hidden = true
            jtDayView.dotView.backgroundColor = UIColor.redColor()
            jtDayView.textLabel.textColor = UIColor.whiteColor()
        }
    }
    
    func calendarBuildWeekDayView(calendar: JTCalendarManager!) -> UIView! {
        
        let view = JTCalendarWeekDayView()
        
        for label in view.dayViews {
            (label as! UILabel).textColor = UIColor.init(red: 185/255.0, green: 211/255.0, blue: 228/255.0, alpha: 1.0)
            (label as! UILabel).font = Utilities.fontWithSize(14)
        }
        
        return view
    }
    
    func calendarBuildDayView(calendar: JTCalendarManager!) -> UIView! {
        
        let view = JTCalendarDayView()
        
        view.textLabel.font = Utilities.fontWithSize(13)
        view.circleRatio = 0.8
        view.dotRatio = 1.0 / 0.9
        
        return view
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
        let jtDayView = dayView as! JTCalendarDayView
        selectedDate = jtDayView.date
        let stringDate = Utilities.stringFromDateNoTimezone(selectedDate, formatStr: genericTimeFormat)
        SharedDataManager.sharedInstance.chosenCalendarDate = stringDate
        NSNotificationCenter.defaultCenter().postNotificationName("RefreshTitle", object: nil)
        if (SharedDataManager.sharedInstance.shouldGetUserInfo == true){
        self.getUserSchedule()
        }
        else{
        self.getSchedule()
        }
        // Update Title
        self.updateTitleWithSelectedDate()
        self.hideCalendar()

        
        
        // Animation for circleView
        jtDayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)
        
        UIView.transitionWithView(jtDayView,
            duration: 0.3,
            options: UIViewAnimationOptions(rawValue: 0),
            animations: { () -> Void in
                jtDayView.circleView.transform = CGAffineTransformIdentity
                self.calendarManager.reload()
            })
            { (completed) -> Void in }
        
        // Load the previous or next page if touch a day from another month
        if(!calendarManager.dateHelper.date(self.calendarContentView.date, isTheSameMonthThan: jtDayView.date)) {
            if (calendarContentView.date.compare(jtDayView.date) == NSComparisonResult.OrderedAscending) {
                calendarContentView.loadNextPageWithAnimation()
            } else {
                calendarContentView.loadPreviousPageWithAnimation()
            }
        }
       
    }
    
    // Calendar View Custom
    func calendarBuildMenuItemView(calendar: JTCalendarManager!) -> UIView! {
        
        let label = UILabel.init()
        label.textAlignment = .Center
        label.font = Utilities.fontWithSize(16)
        return label
    }
    
    // MARK: - DayScheduleViewControllerDelegate
    func shiftDidSelect(shiftObj: NSShift) {
        
        if (self.isFromRequest || self.isFromPickOpenShiftRequest) {
            if ((self.requestDelegate?.shiftDidSelect(shiftObj) != nil)) {
                self.navigationController?.popViewControllerAnimated(true)
            }
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
    //API calls
    func getSchedule(){
        switch self.segmentNumber{
        case 0:
            self.getScheduleForDay()
            break
        case 1:
            self.getScheduleForWeek()
            break
        case 2:
            self.getScheduleForMonth()
            break
        default:
            break
        }
    }
    
    func getUserSchedule(){
        switch self.segmentNumber{
        case 0:
            self.userScheduleViewMode = "Day"
              SharedDataManager.sharedInstance.userScheduleView = "Day"
            break
        case 1:
           self.userScheduleViewMode = "Week"
               SharedDataManager.sharedInstance.userScheduleView = "Week"
            break
        case 2:
           self.userScheduleViewMode = "Month"
               SharedDataManager.sharedInstance.userScheduleView = "Month"
            break
        default:
            break
        }
     /*  //SVProgressHUD.show()
        self.userFilter =  NSUserScheduleFilter()
      //  self.userFilter!.startAt = Utilities.stringFromDate(NSDate(), formatStr: genericTimeFormat)
        self.userFilter!.scheduleViewType = self.userScheduleViewMode
        self.userFilter?.startAt = SharedDataManager.sharedInstance.chosenCalendarDate
        NSAPIClient.sharedInstance.getScheduleForUser(self.userFilter!) { (nsData, error) -> Void in
            SVProgressHUD.dismiss()
            if(error == nil){           
                      self.scheduleUser = NSScheduleUser.initWithDictionary((nsData as? NSDictionary)!)
                SharedDataManager.sharedInstance.userSchedule = self.scheduleUser
                NSNotificationCenter.defaultCenter().postNotificationName("RefreshUserTable", object: nil)
           print(nsData as? NSDictionary)
            }
            else{
            print("failed")
            }
        }*/
              NSNotificationCenter.defaultCenter().postNotificationName("RefreshUserScheduleUser", object: nil)
    }
    
    
       func getScheduleForWeek(){
      
       // SVProgressHUD.show()
        /*
        NSAPIClient.sharedInstance.getScheduleForWeek(self.weekFilter!) { (nsData, error) -> Void in
            if(error == nil){
                SVProgressHUD.dismiss()
                let schedule = nsData as! NSDictionary
                self.scheduleWeek!.days = (schedule.objectForKey("days") as? NSDictionary)!
                self.scheduleWeek!.employees = (schedule.objectForKey("employees") as? NSArray)!
                self.scheduleWeek!.openShifts = (schedule.objectForKey("openShifts") as? NSArray)!
                SharedDataManager.sharedInstance.weekSchedule = self.scheduleWeek
           //     SharedDataManager.sharedInstance.weakScheduleFilter = self.weekFilter
                SharedDataManager.sharedInstance.shouldGetUserInfo = self.shouldGetUserInfo
                              let weekNumber = Utilities.getWeek(Utilities.dateFromString(self.weekFilter!.currentDate, isShortForm: true)!)
                var weekSchedule = NSScheduleWeek()
                weekSchedule = weekSchedule?.initWithDictionary(schedule)
                weekSchedule?.returnDays(weekSchedule!)
                print(schedule)
           
            }
            else{
                SVProgressHUD.dismiss()
                Utilities.showMsg(NSLocalizedString("Failed getting week schedule", comment: "Failed getting week schedule"), delegate: self)
            }*/
       // }
        NSNotificationCenter.defaultCenter().postNotificationName("RefreshScheduleWeek", object: nil)

    }
    
    func getScheduleForDay(){
       // SVProgressHUD.show()
      /*  self.setDayFilterInfo()
       self.dayFilter?.startAt = SharedDataManager.sharedInstance.chosenCalendarDate
        
     NSAPIClient.sharedInstance.getScheduleForDay(self.dayFilter!) { (nsData, error) -> Void in
        SVProgressHUD.dismiss()
        if(error == nil){
            let dict = nsData as! NSDictionary
            self.scheduleDay?.employees = dict.valueForKey("employees") as! NSArray
            self.scheduleDay?.openShifts = dict.valueForKey("openShifts") as! NSArray
            self.scheduleDay?.startAt = dict.valueForKey("startAt") as! String
            print (self.scheduleDay?.convertToDictionary())
            SharedDataManager.sharedInstance.daySchedule = self.scheduleDay
            NSNotificationCenter.defaultCenter().postNotificationName("RefreshDayTable", object: nil)
        }
        else{
        Utilities.showMsgWithTitle(NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("Failed getting day schedule", comment: "Failed getting day schedule"), delegate: nil)
        }
        }*/
        NSNotificationCenter.defaultCenter().postNotificationName("RefreshDayTable", object: nil)
        
    }
    
    func getScheduleForMonth(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("RefreshMonthTable", object: nil)

      //  SVProgressHUD.show()
       }
     //Pragma notification
    //Notification for refreshing date from other activities
    func updateTitleForDay (notification : NSNotification){
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "MMMM yyyy"
        titleButton.setTitle(dateFormatter.stringFromDate(Utilities.dateFromStringHours(SharedDataManager.sharedInstance.chosenCalendarDate, format: genericTimeFormat)), forState: .Normal)

    }   
 
    
}
