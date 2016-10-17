//
//  MyAvailViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 10/13/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class CustomAvailTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        
        if titleLabel != nil {
            titleLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("\(LocalizeHelper.sharedInstance.localizedStringForKey("I_am_available_on")) Sundays")
        }
        fromDateButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("From"), forState: .Normal)
        endDateButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("To"), forState: .Normal)
    }
}

class MyAvailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SBPickerSelectorDelegate, CreateAvailabilityViewControllerDelegate {
    
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var availTable: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var availDayLabel: UILabel!
    @IBOutlet weak var availDaySwitch: UISwitch!
    @IBOutlet weak var allDaySwitch: UISwitch!
    @IBOutlet weak var topViewHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var weekViewHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var setEverydayButton: UIButton!
    @IBOutlet weak var allDayLabel: UILabel!
    
    var availArray = NSMutableArray()
    var customAvailArray = NSMutableArray()
    var timePicker: SBPickerSelector!

    private let cellIdentifier = "AvailCell"
    private let cellHeight = 70.0
    
    var selDayIndex = 0
    var isAdd = false
    var selIndex = 0
    var curInputCell: CustomAvailTableCell? = nil
    var curInputStartDate: NSDate? = nil
    var curInputEndDate: NSDate? = nil
    var curCustomIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()
        
        self.buildWeekView()
        let border = Utilities.createBorder(edge: UIRectEdge.All, colour: UIColor.lightGrayColor(), thickness: 0.5, frame: topView.frame)
        topView.layer.addSublayer(border)
        bottomView.layer.addSublayer(border)
        Utilities.decorateTableView(availTable)
        
        self.initializePickers()
        
        let avail = NSAvailability()
        availArray = [avail!]
        
        let sampleAvail = NSAvailability()
        sampleAvail?.title = "Year End Holidays"
        customAvailArray = [sampleAvail!]
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.updateContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("MyAvailability")
        typeSegment.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("Details"), forSegmentAtIndex: 0)
        typeSegment.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("Custom"), forSegmentAtIndex: 1)
        setEverydayButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("SET_THIS_EVERYDAY"), forState: .Normal)
        allDayLabel.text = "\(LocalizeHelper.sharedInstance.localizedStringForKey("All_Day")) (12am - 11:59pm)"
        
    }
    
    // MARK: - UI Utility
    func initializePickers() {
        self.timePicker = SBPickerSelector.picker()
        self.timePicker.pickerType = SBPickerSelectorType.Date
        self.timePicker.onlyDayPicker = false
        self.timePicker.datePickerType = SBPickerSelectorDateType.OnlyHour
        self.timePicker.doneButton?.title = LocalizeHelper.sharedInstance.localizedStringForKey("Done")
        self.timePicker.cancelButton?.title = LocalizeHelper.sharedInstance.localizedStringForKey("Cancel")
        self.timePicker.delegate=self
    }
    
    // MARK: - UI Utility Functions
    func updateContent() {
        
        if typeSegment.selectedSegmentIndex == 0 {
            self.bottomView.hidden = false
            self.topView.hidden = false
            self.topViewHeiConstraint.constant = 45
            self.plusButton.hidden = true
            self.weekView.hidden = false
            self.weekViewHeiConstraint.constant = 40

            UIView.animateWithDuration(0.3) { () -> Void in
                
                var height: CGFloat = -1
                if self.availDaySwitch.on {
                    
                    self.bottomView.hidden = false
                    
                    if self.allDaySwitch.on {
                        height = -1
                    } else {
                        let availHei = SCRN_HEIGHT - 64 - 88 - 56 - 45 - 45
                        if availHei < CGFloat(self.availArray.count + 1) * CGFloat(self.cellHeight) {
                            height = availHei
                        } else {
                            height = CGFloat(self.availArray.count + 1) * CGFloat(self.cellHeight)
                        }
                    }
                } else {
                    self.bottomView.hidden = true
                }
                
                self.tableHeiConstraint.constant = height
                
                self.view.layoutIfNeeded()
            }
            
            self.availTable.reloadData()

        } else {
            self.bottomView.hidden = true
            self.topView.hidden = true
            self.plusButton.hidden = false
            self.weekView.hidden = true
            self.weekViewHeiConstraint.constant = 0
            
            self.topViewHeiConstraint.constant = 0
            let availHei = SCRN_HEIGHT - 64 - 40 - 8 - 8
            self.tableHeiConstraint.constant = availHei
            
            self.availTable.reloadData()
        }
    }
    
    func buildWeekView() {
        
        let wid = SCRN_WIDTH / 7
        let hei = weekView.frame.size.height
        
        let dayArray = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        for i in 0...dayArray.count-1 {
            let button = UIButton.init(frame: CGRectMake(wid*CGFloat(i), 0, wid, hei))
            button.setTitle(dayArray[i], forState: .Normal)
            button.tag = i+1
            button.addTarget(self, action: Selector("onClickDay:"), forControlEvents: .TouchUpInside)
            
            if i == selDayIndex {
                button.backgroundColor = GREEN_COLOR
                availDayLabel.text = "\(LocalizeHelper.sharedInstance.localizedStringForKey("I_am_available_on")) \(["Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays", "Sundays"][i])"
            }
            
            weekView.addSubview(button)
        }
    }
    
    // MARK: - UIButton Action
    func onClickDay(sender: UIButton) {
        
        selDayIndex = sender.tag - 1
        for i in 0...6 {
            let button = weekView.viewWithTag(i+1) as? UIButton
            if button != nil {
                if i == selDayIndex {
                    button?.backgroundColor = GREEN_COLOR
                    availDayLabel.text = "\(LocalizeHelper.sharedInstance.localizedStringForKey("I_am_available_on")) \(["Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays", "Sundays"][i])"
                } else {
                    button?.backgroundColor = UIColor.clearColor()
                }
            }
        }
        self.updateContent()
    }
    
    @IBAction func onClickPlus(sender: AnyObject) {
        
        isAdd = true
        self.performSegueWithIdentifier(kShowCustomAvailVC, sender: self)
    }

    // MARK: - On Segment Change
    @IBAction func onSegmentChange(sender: AnyObject) {
        
        self.updateContent()
    }
    
    // MARK: - On Switch Change
    @IBAction func onAvailSundaySwitch(sender: AnyObject) {
        
        self.updateContent()
    }
    
    @IBAction func onAllDaySwitch(sender: AnyObject) {
        
        self.updateContent()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return typeSegment.selectedSegmentIndex == 0 ? CGFloat(cellHeight) : CGFloat(90)
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return typeSegment.selectedSegmentIndex == 0 ? availArray.count + 1 : customAvailArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = typeSegment.selectedSegmentIndex == 0 ? cellIdentifier : "CustomCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        let customAvailCell = cell as! CustomAvailTableCell
        
        if typeSegment.selectedSegmentIndex == 0 {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mmaa"
            
            if indexPath.row < availArray.count {
                let availObj = availArray[indexPath.row] as! NSAvailability
                customAvailCell.fromDateButton.setTitle(dateFormatter.stringFromDate(availObj.startAt), forState: .Normal)
                customAvailCell.endDateButton.setTitle(dateFormatter.stringFromDate(availObj.endAt), forState: .Normal)
                customAvailCell.endDateButton.tag = 2
                customAvailCell.fromDateButton.tag = 2
                customAvailCell.deleteButton.hidden = false
                customAvailCell.deleteButton.addTarget(self, action: Selector("onClickDelete:"), forControlEvents: .TouchUpInside)
                customAvailCell.deleteButton.tag = indexPath.row
            } else {
                curInputCell = customAvailCell
                
                customAvailCell.deleteButton.hidden = true
                customAvailCell.deleteButton.removeTarget(self, action: Selector("onClickDelete:"), forControlEvents: .TouchUpInside)
                
                customAvailCell.fromDateButton.addTarget(self, action: Selector("onClickDate:"), forControlEvents: .TouchUpInside)
                customAvailCell.fromDateButton.tag = 0
                
                customAvailCell.endDateButton.addTarget(self, action: Selector("onClickDate:"), forControlEvents: .TouchUpInside)
                customAvailCell.endDateButton.tag = 1
                
                let startTitle = curInputStartDate != nil ? dateFormatter.stringFromDate(curInputStartDate!) : "From"
                customAvailCell.fromDateButton.setTitle(startTitle, forState: .Normal)
                
                let endTitle = curInputEndDate != nil ? dateFormatter.stringFromDate(curInputEndDate!) : "To"
                customAvailCell.endDateButton.setTitle(endTitle, forState: .Normal)
            }
        
        } else if typeSegment.selectedSegmentIndex == 1 {
            let availObj = customAvailArray[indexPath.row] as! NSAvailability
            customAvailCell.titleLabel.text = availObj.title
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy | h:mmaa"
            
            customAvailCell.fromDateButton.setTitle(dateFormatter.stringFromDate(availObj.startAt), forState: .Normal)
            customAvailCell.endDateButton.setTitle(dateFormatter.stringFromDate(availObj.endAt), forState: .Normal)
            
            customAvailCell.deleteButton.tag = indexPath.row
            customAvailCell.deleteButton.addTarget(self, action: Selector("onClickCustomCellDelete:"), forControlEvents: .TouchUpInside)
        }
        
        return cell
    }
    
    func onClickDate(sender: UIButton) {
        
        if sender.tag == 2 { // Buttons that has been input
            return
        }
        self.timePicker.datePickerView.tag = sender.tag
        self.timePicker.showPickerOver(self)
    }
    
    func onClickDelete(sender: UIButton) {
    
        // Create the alert controller
        let alertController = UIAlertController(title: kTitle_APP, message: "Do you want to delete this?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.availArray.removeObjectAtIndex(sender.tag)
            self.updateContent()
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func onClickCustomCellDelete(sender: UIButton) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: kTitle_APP, message: "Do you want to delete this?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.customAvailArray.removeObjectAtIndex(sender.tag)
            self.availTable.reloadData()
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selIndex = indexPath.row
        if typeSegment.selectedSegmentIndex == 1 {
            isAdd = false
            curCustomIndex = indexPath.row
            self.performSegueWithIdentifier(kShowCustomAvailVC, sender: self)
        }
    }
    
    // MARK: - SBPickerDelegate
    func pickerSelector(selector: SBPickerSelector!, dateSelected date: NSDate!) {
        
        if selector.datePickerView.tag == 0 { // Start Date Picker
            curInputStartDate = date
        } else {
            curInputEndDate = date
        }
        
        if curInputStartDate != nil && curInputEndDate != nil {
            let newAvail = NSAvailability()
            newAvail?.startAt = curInputStartDate!
            newAvail?.endAt = curInputEndDate!
            availArray.addObject(newAvail!)
            
            curInputStartDate = nil
            curInputEndDate = nil
        }
        availTable.reloadData()
        self.updateContent()
    }
    
    // MARK: - CreateCustomAvailabilityDelegate
    func availabilityAdded(availObj: NSAvailability) {
        
        customAvailArray.addObject(availObj)
        self.availTable.reloadData()
    }
    
    func availabilityUpdated(availObj: NSAvailability) {
        
        customAvailArray.replaceObjectAtIndex(curCustomIndex, withObject: availObj)
        self.availTable.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == kShowCustomAvailVC {
            let destVC = segue.destinationViewController as! CreateAvailabilityViewController
            destVC.isCreate = isAdd
            destVC.delegate = self
            
            if isAdd == false {
                destVC.availData = customAvailArray[selIndex] as? NSAvailability
            }
        }
    }

}
