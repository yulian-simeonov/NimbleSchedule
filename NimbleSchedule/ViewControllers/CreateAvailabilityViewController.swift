//
//  CreateAvailabilityViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 1/7/16.
//
//

import UIKit

class AvailDateTableCell: UITableViewCell {
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
}

protocol CreateAvailabilityViewControllerDelegate {
    func availabilityAdded(availObj: NSAvailability)
    func availabilityUpdated(availObj: NSAvailability)
}

class CreateAvailabilityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SBPickerSelectorDelegate {

    var delegate: CreateAvailabilityViewControllerDelegate? = nil
    var availData: NSAvailability? = nil
    
    @IBOutlet weak var availTable: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private let kDateFormat = "MMM dd, yyyy"
    private let kTimeFormat = "hh:mmaa"
    
    var datePicker: SBPickerSelector!
    var howOftenPicker: SBPickerSelector!
    
    var titleTextField: UITextField? = nil
    var howOftenTextField: UITextField? = nil
    var notesTextView: UITextView? = nil
    
    var howOften = ""
    var startDateStr = LocalizeHelper.sharedInstance.localizedStringForKey("Date");
    var startTimeStr = LocalizeHelper.sharedInstance.localizedStringForKey("Time")
    var endDateStr = LocalizeHelper.sharedInstance.localizedStringForKey("Date");
    var endTimeStr = LocalizeHelper.sharedInstance.localizedStringForKey("Time")
    
    var isCreate: Bool = false
    
    let cellIdentifiers = ["TitleCell", "StartDateCell", "EndDateCell", "HowOftenCell", "NotesCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addButton.setTitle(isCreate ? LocalizeHelper.sharedInstance.localizedStringForKey("ADD AVAILABILITY") : LocalizeHelper.sharedInstance.localizedStringForKey("APPLY"), forState: .Normal)
        self.initializePickers()
        
        if !isCreate && availData != nil {
            howOften = availData!.howOften
            startDateStr = Utilities.stringFromDate(availData?.startAt, formatStr: kDateFormat)
            startTimeStr = Utilities.stringFromDate(availData?.startAt, formatStr: kTimeFormat)
            endDateStr = Utilities.stringFromDate(availData?.endAt, formatStr: kDateFormat)
            endTimeStr = Utilities.stringFromDate(availData?.endAt, formatStr: kTimeFormat)
            notesTextView?.text = availData?.notes
        }
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
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("CustomAvailability")
        addButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("ADD_AVAILABILITY"), forState: .Normal)
    }
    
    // MARK: - UI Utility
    func initializePickers() {
        
        self.datePicker = SBPickerSelector.picker()
        self.datePicker.pickerType = SBPickerSelectorType.Date
        self.datePicker.onlyDayPicker = false
        self.datePicker.datePickerType = SBPickerSelectorDateType.Default
        self.datePicker.doneButton?.title = LocalizeHelper.sharedInstance.localizedStringForKey("Done")
        self.datePicker.cancelButton?.title = LocalizeHelper.sharedInstance.localizedStringForKey("Cancel")
        self.datePicker.delegate=self
        
        self.howOftenPicker = SBPickerSelector.picker()
        self.howOftenPicker.pickerType = SBPickerSelectorType.Text
        self.howOftenPicker.pickerData = ["Just once", "Two days", "Every sunday"]
        self.howOftenPicker.doneButton?.title = LocalizeHelper.sharedInstance.localizedStringForKey("Done")
        self.howOftenPicker.cancelButton?.title = LocalizeHelper.sharedInstance.localizedStringForKey("Cancel")
        self.howOftenPicker.delegate=self
    }

    // MARK: - UIButton Action
    @IBAction func onClickClose(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func onClickAdd(sender: AnyObject) {
        
        if self.delegate != nil {
            if titleTextField!.text!.isEmpty {
                Utilities.showMsg("Please input title", delegate: self)
                return
            }
            
            if startDateStr.isEmpty || startTimeStr.isEmpty || endDateStr.isEmpty || endTimeStr.isEmpty ||
            startDateStr == LocalizeHelper.sharedInstance.localizedStringForKey("Date") || startTimeStr == LocalizeHelper.sharedInstance.localizedStringForKey("Time") || endDateStr == LocalizeHelper.sharedInstance.localizedStringForKey("Date") || endTimeStr == LocalizeHelper.sharedInstance.localizedStringForKey("Time") {
                Utilities.showMsg(LocalizeHelper.sharedInstance.localizedStringForKey("Please_fill_all_date_fields"), delegate: self)
                return
            }
            
            let newAvailObj = NSAvailability()
            newAvailObj?.title = titleTextField!.text!
            newAvailObj?.startAt = Utilities.dateFromStringLocal(startDateStr + " " + startTimeStr, format: kDateFormat + " " + kTimeFormat)
            newAvailObj?.endAt = Utilities.dateFromStringLocal(endDateStr + " " + endTimeStr, format: kDateFormat + " " + kTimeFormat)
            newAvailObj?.notes = notesTextView!.text
            newAvailObj?.howOften = howOften
            
            if isCreate {
                if self.delegate?.availabilityAdded(newAvailObj!) != nil {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            } else {
                if self.delegate?.availabilityUpdated(newAvailObj!) != nil {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellIdentifiers.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return indexPath.row == 4 ? tableView.frame.size.height-50*4 : 50
    }
    
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifiers[indexPath.row], forIndexPath: indexPath)
        
        if indexPath.row == 0 { // Title Cell
            titleTextField = cell.viewWithTag(1) as? UITextField
            titleTextField?.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("Title")
            if titleTextField?.text?.isEmpty == true && availData != nil {
                titleTextField?.text = availData?.title
            }
        }
        
        if indexPath.row == 1 || indexPath.row == 2 { // Start and End date Cell
            let dateCell = cell as! AvailDateTableCell
            
            if indexPath.row == 1 {
                dateCell.dateButton.setTitle(startDateStr, forState: .Normal)
                dateCell.timeButton.setTitle(startTimeStr, forState: .Normal)
            }
            
            if indexPath.row == 2 {
                dateCell.dateButton.setTitle(endDateStr, forState: .Normal)
                dateCell.timeButton.setTitle(endTimeStr, forState: .Normal)
            }
            
            dateCell.tag = indexPath.row
            
            dateCell.dateButton.tag = indexPath.row
            dateCell.timeButton.tag = indexPath.row
            dateCell.dateButton.addTarget(self, action: Selector("onClickDate:"), forControlEvents: .TouchUpInside)
            dateCell.timeButton.addTarget(self, action: Selector("onClickTime:"), forControlEvents: .TouchUpInside)
            
            if availData != nil {
                let date = indexPath.row == 1 ? availData?.startAt : availData?.endAt
            }
        }
        
        if indexPath.row == 3 { // How Often Cell
            howOftenTextField = cell.viewWithTag(1) as? UITextField
            howOftenTextField?.text = howOften
            howOftenTextField?.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("How_Often")
        }
        
        if indexPath.row == 4 { // Notes
            notesTextView = cell.viewWithTag(1) as? UITextView
            (notesTextView as! NSPlaceholderTextView).placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("Notes")
        }
        
        return cell
    }
    
    func onClickDate(sender: UIButton) {
        
        self.datePicker.datePickerView.tag = sender.tag
        self.datePicker.datePickerType = .OnlyDay
        self.datePicker.showPickerOver(self)
    }
    
    func onClickTime(sender: UIButton) {
        
        self.datePicker.datePickerView.tag = sender.tag
        self.datePicker.datePickerType = .OnlyHour
        self.datePicker.showPickerOver(self)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 3 {
            self.howOftenPicker.showPickerOver(self)
        }
    }
    
    // MARK: - SBPickerDelegate
    func pickerSelector(selector: SBPickerSelector!, dateSelected date: NSDate!) {
        
        if selector == self.datePicker {
            if self.datePicker.datePickerType == .OnlyDay {
                if self.datePicker.datePickerView.tag == 1 { // Start Date
                    startDateStr = Utilities.stringFromDate(date, formatStr: kDateFormat)
                } else { // End Date
                    endDateStr = Utilities.stringFromDate(date, formatStr: kDateFormat)
                }
            } else {
                if self.datePicker.datePickerView.tag == 1 { // Start Time
                    startTimeStr = Utilities.stringFromDate(date, formatStr: kTimeFormat)
                } else { // End Time
                    endTimeStr = Utilities.stringFromDate(date, formatStr: kTimeFormat)
                }
            }
        }
        availTable.reloadData()
    }

    func pickerSelector(selector: SBPickerSelector!, selectedValue value: String!, index idx: Int) {
        
        if selector == self.howOftenPicker {
            howOften = value
            
            availTable.reloadData()
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

}
