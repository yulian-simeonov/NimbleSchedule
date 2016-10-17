//
//  HoursOfOperationViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 12/23/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class HoursTableCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startsAtButton: UIButton!
    @IBOutlet weak var endsAtButton: UIButton!
    @IBOutlet weak var closedSwitch: UISwitch!
    
}

protocol HoursOfOperationViewControllerDelegate {
    func hoursOfOperationDidEdited(hoursOperationObj: NSHoursOperation)
}

class HoursOfOperationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SBPickerSelectorDelegate {
    
    private let cellIdentifier = "HoursCell"
    
    var delegate: HoursOfOperationViewControllerDelegate? = nil
    
    var hoursOperationData = NSHoursOperation()
    var dayArray = ["SAT", "SUN", "MON", "TUE", "WED", "THU", "FRI"]
    
    @IBOutlet weak var hoursTable: UITableView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var sameStartPicker : SBPickerSelector!
    var sameEndPicker : SBPickerSelector!
    var hourPicker : SBPickerSelector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        hoursTable.tableFooterView = UIView()
        self.hoursOperationData = SharedDataManager.sharedInstance.hours
        if(self.hoursOperationData == nil){
        self.hoursOperationData = NSHoursOperation()
        }
        self.makeUpView()
        self.initiatePickers()
    }
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Mark selectors
    func initiatePickers(){
        self.sameStartPicker = SBPickerSelector.picker()
        self.sameStartPicker.pickerType = SBPickerSelectorType.Date
        self.sameStartPicker.onlyDayPicker = true
        self.sameStartPicker.datePickerType = SBPickerSelectorDateType.OnlyHour
        self.sameStartPicker.doneButton?.title = NSLocalizedString("Done", comment: "Done")
        self.sameStartPicker.cancelButton?.title = NSLocalizedString("Cancel", comment: "Cancel")
        self.sameStartPicker.delegate=self
        
        self.sameEndPicker = SBPickerSelector.picker()
        self.sameEndPicker.pickerType = SBPickerSelectorType.Date
        self.sameEndPicker.onlyDayPicker = true
        self.sameEndPicker.datePickerType = SBPickerSelectorDateType.OnlyHour
        self.sameEndPicker.doneButton?.title = NSLocalizedString("Done", comment: "Done")
        self.sameEndPicker.cancelButton?.title = NSLocalizedString("Cancel", comment: "Cancel")
        self.sameEndPicker.delegate=self
        
        self.hourPicker = SBPickerSelector.picker()
        self.hourPicker.pickerType = SBPickerSelectorType.Date
        self.hourPicker.onlyDayPicker = true
        self.hourPicker.datePickerType = SBPickerSelectorDateType.OnlyHour
        self.hourPicker.doneButton?.title = NSLocalizedString("Done", comment: "Done")
        self.hourPicker.cancelButton?.title = NSLocalizedString("Cancel", comment: "Cancel")
        self.hourPicker.delegate=self
       
        
    }
    
    @IBAction func showSameStartPicker(){
    self.sameStartPicker.showPickerOver(self)
    }
    
    @IBAction func showSameEndPicker(){
    self.sameEndPicker.showPickerOver(self)
    }
    
    @IBAction func showHourPicker(){
    self.hourPicker.showPickerOver(self)
    }
    
    func pickerSelector(selector: SBPickerSelector!, var dateSelected date: NSDate!){
        //let stringDate = Utilities.stringFromDate(date, formatStr: "hh:mm aa")
               //hour picking
        date = Utilities.dateWithUTCTimeZone(date)
        if(selector == self.hourPicker){
            self.hoursTable.alpha = 1.0
            self.hoursTable.userInteractionEnabled = true
            
            let index = self.hourPicker.index / 10
            let isStartTime = self.hourPicker.index  % 10 == 1
            let hoursDayObj = self.getHoursDay(dayArray[index])
            
            if isStartTime {
                self.hoursOperationData?.sameOpenTimeEveryday = false
                hoursDayObj.startsTime = date
                self.setHoursDay(index, hours: hoursDayObj)
                
            } else {
                self.hoursOperationData?.sameCloseTimeEveryday = false
                hoursDayObj.endsTime = date
                self.setHoursDay(index, hours: hoursDayObj)
            }
            
            self.hoursTable.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: index, inSection: 0)], withRowAnimation: .Middle)
        }
        //same start picking
        if(selector == self.sameStartPicker){
        self.hoursOperationData?.monHours.closedOn = false
        self.hoursOperationData?.thuHours.closedOn = false
        self.hoursOperationData?.tueHours.closedOn = false
        self.hoursOperationData?.wedHours.closedOn = false
        self.hoursOperationData?.friHours.closedOn = false
        self.hoursOperationData?.satHours.closedOn = false
        self.hoursOperationData?.sunHours.closedOn = false
        self.hoursOperationData?.monHours.startsTime = date
        self.hoursOperationData?.tueHours.startsTime = date
        self.hoursOperationData?.wedHours.startsTime = date
        self.hoursOperationData?.thuHours.startsTime = date
        self.hoursOperationData?.friHours.startsTime = date
        self.hoursOperationData?.satHours.startsTime = date
        self.hoursOperationData?.sunHours.startsTime = date
        self.hoursTable.reloadData()
        }
        else if (selector == self.sameEndPicker){
            self.hoursOperationData?.monHours.closedOn = false
            self.hoursOperationData?.thuHours.closedOn = false
            self.hoursOperationData?.tueHours.closedOn = false
            self.hoursOperationData?.wedHours.closedOn = false
            self.hoursOperationData?.friHours.closedOn = false
            self.hoursOperationData?.satHours.closedOn = false
            self.hoursOperationData?.sunHours.closedOn = false
            self.hoursOperationData?.monHours.endsTime = date
            self.hoursOperationData?.tueHours.endsTime = date
            self.hoursOperationData?.wedHours.endsTime = date
            self.hoursOperationData?.thuHours.endsTime = date
            self.hoursOperationData?.friHours.endsTime = date
            self.hoursOperationData?.satHours.endsTime = date
            self.hoursOperationData?.sunHours.endsTime = date
            self.hoursTable.reloadData()
        }
    }
    
    
    // MARK: - UIButton Action
    
    @IBAction func onClickDone(sender: AnyObject) {
        SharedDataManager.sharedInstance.hours = self.hoursOperationData
       // if self.delegate?.hoursOfOperationDidEdited(self.hoursOperationData!) != nil {
            self.navigationController?.popViewControllerAnimated(true)
       // }
    }
    
    func onClickDate(sender: UIButton) {
        self.hoursTable.alpha = 0.6
        self.hoursTable.userInteractionEnabled = false
        self.hourPicker.index = sender.tag
        self.hourPicker.showPickerOver(self)
        
    }
    
    /**@IBAction func onClickPickerDone(sender: AnyObject) {
        self.hoursTable.alpha = 1.0
        self.hoursTable.userInteractionEnabled = true
        self.showDatePicker(false)
        
        let index = self.datePicker.tag / 10
        let isStartTime = self.datePicker.tag % 10 == 1
        let hoursDayObj = self.getHoursDay(dayArray[index])
        
        if isStartTime {
            self.hoursOperationData?.sameOpenTimeEveryday = false
            hoursDayObj.startsTime = self.datePicker.date
            self.setHoursDay(index, hours: hoursDayObj)
            
        } else {
            self.hoursOperationData?.sameCloseTimeEveryday = false
            hoursDayObj.endsTime = self.datePicker.date
            self.setHoursDay(index, hours: hoursDayObj)
        }
        
        self.hoursTable.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: index, inSection: 0)], withRowAnimation: .Middle)
    }*/
    
    @IBAction func onClickSameEnd(sender: AnyObject) {
        
     //   var sameDate: NSDate?
      /*  for day in dayArray {
            let hoursDay = self.getHoursDay(day)
            if sameDate == nil {
                if !hoursDay.closedOn {
                   // sameDate = hoursDay.endsTime
                    //self.hoursOperationData?.closeTimeEveryDay = sameDate
                                 }
            }
            //hoursDay.endsTime = sameDate
        }*/
       // self.hoursOperationData?.sameCloseTimeEveryday = true
       // self.hoursTable.reloadData()
        self.sameEndPicker.showPickerOver(self)

    }
    
    @IBAction func onClickSameStart(sender: AnyObject) {
        
       // var sameDate: NSDate?
    /*    for day in dayArray {
            let hoursDay = self.getHoursDay(day)
            if sameDate == nil {
                if !hoursDay.closedOn {
                 //   sameDate = hoursDay.startsTime
                  //  self.hoursOperationData?.openTimeEveryDay = sameDate
                                 }
            }
           // hoursDay.startsTime = sameDate
        }
        */
        self.sameStartPicker.showPickerOver(self)

       // self.hoursOperationData?.sameOpenTimeEveryday = true
        //self.hoursTable.reloadData()
    }
    
    func onSwitchChange(sender: UISwitch) {
        let index = sender.tag
        let hoursDayObj = self.getHoursDay(dayArray[index])
        hoursDayObj.closedOn = sender.on
         hoursDayObj.startsTime = nil
        hoursDayObj.endsTime = nil
        self.setHoursDay(index, hours: hoursDayObj)
        self.hoursTable.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: index, inSection: 0)], withRowAnimation: .Middle)
        
    }
    // MARK: - UI Utility Functions
    func makeUpView() {
        
        datePickerView.transform = CGAffineTransformMakeTranslation(0, 260)
        datePickerView.layer.borderColor = GRAY_COLOR_3.CGColor
        datePickerView.layer.borderWidth = 1.0
        
        datePicker.layer.borderColor = GRAY_COLOR_3.CGColor
        datePicker.layer.borderWidth = 1.0
    }
    
    func showDatePicker(isShow: Bool) {
        if isShow && self.datePickerView.transform.ty == 0 {
            return
        }
        self.datePickerView.transform = isShow ? CGAffineTransformMakeTranslation(0, 260) : CGAffineTransformMakeTranslation(0, 0)
        UIView.animateWithDuration(0.5) { () -> Void in
            self.datePickerView.transform = isShow ? CGAffineTransformMakeTranslation(0, 0) : CGAffineTransformMakeTranslation(0, 260)
        }
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = true
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 33))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let descLabel = UILabel.init(frame: CGRectMake(10, 5, 250, 23))
        descLabel.text = NSLocalizedString("HOURS OF OPERATION", comment: "HOURS OF OPERATION")
        descLabel.textColor = UIColor.darkGrayColor()
        descLabel.font = Utilities.fontWithSize(12.0)
        descLabel.backgroundColor = UIColor.clearColor()
        headerView .addSubview(descLabel)
        
        headerView.layer.borderColor = GRAY_COLOR_6.CGColor
        headerView.layer.borderWidth = 0.5
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func getHoursDay(dayStr: String) -> NSHoursOperationDay {
        
        var hoursDayObj: NSHoursOperationDay?
        if dayStr == "SAT" {
            hoursDayObj = (self.hoursOperationData?.satHours)!
        } else if dayStr == "SUN" {
            hoursDayObj = (self.hoursOperationData?.sunHours)!
        } else if dayStr == "MON" {
            hoursDayObj = (self.hoursOperationData?.monHours)!
        } else if dayStr == "TUE" {
            hoursDayObj = (self.hoursOperationData?.tueHours)!
        } else if dayStr == "WED" {
            hoursDayObj = (self.hoursOperationData?.wedHours)!
        } else if dayStr == "THU" {
            hoursDayObj = (self.hoursOperationData?.thuHours)!
        } else if dayStr == "FRI" {
            hoursDayObj = (self.hoursOperationData?.friHours)!
        }
        return hoursDayObj!
    }
    
    func setHoursDay ( index : NSInteger, hours : NSHoursOperationDay){
        if (index == 0){
        self.hoursOperationData?.satHours = hours
        }
        else if (index == 1){
        self.hoursOperationData?.sunHours = hours
        }
        else if (index == 2){
        self.hoursOperationData?.monHours = hours
        }
        else if (index == 3){
        self.hoursOperationData?.tueHours = hours
        }
        else if (index == 4){
        self.hoursOperationData?.wedHours = hours
        }
        else if (index == 4){
        self.hoursOperationData?.thuHours = hours
        }
        else if (index == 5){
        self.hoursOperationData?.friHours = hours
        }
        SharedDataManager.sharedInstance.hours = self.hoursOperationData
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HoursTableCell
        
        cell.dayLabel.text = dayArray[indexPath.row]
        
        cell.startsAtButton.tag = indexPath.row * 10 + 1
        cell.endsAtButton.tag = indexPath.row * 10 + 2
        cell.closedSwitch.tag = indexPath.row
        
        cell.startsAtButton.addTarget(self, action: Selector("onClickDate:"), forControlEvents: .TouchUpInside)
        cell.endsAtButton.addTarget(self, action: Selector("onClickDate:"), forControlEvents: .TouchUpInside)
        cell.closedSwitch.addTarget(self, action: Selector("onSwitchChange:"), forControlEvents: .ValueChanged)
        
        
        let hoursDayObj = self.getHoursDay(dayArray[indexPath.row])
        
        let startsDate = hoursDayObj.startsTime
        let endsDate = hoursDayObj.endsTime
        let closedOn = hoursDayObj.closedOn
        
        let startsAt = closedOn ? "Starts at" : Utilities.stringFromDate(startsDate, formatStr: "hh:mm aa")
        let endsAt = closedOn ? "Ends at" : Utilities.stringFromDate(endsDate , formatStr: "hh:mm aa")
        
        cell.startsAtButton.setTitle(startsAt, forState: .Normal); cell.startsAtButton.enabled = !closedOn
        cell.endsAtButton.setTitle(endsAt, forState: .Normal); cell.endsAtButton.enabled = !closedOn
        cell.closedSwitch.setOn(closedOn, animated: true)
        
        return cell
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
  
}
