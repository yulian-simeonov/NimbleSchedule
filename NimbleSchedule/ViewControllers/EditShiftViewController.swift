//
//  EditShiftViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/13/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class DateTableCell: UITableViewCell {
    
    @IBOutlet weak var startAtLabel: UILabel!
    @IBOutlet weak var endAtLabel: UILabel!
    @IBOutlet weak var startsDescLabel: UILabel!
    @IBOutlet weak var endsDescLabel: UILabel!
    
}

class DetailWithTextFieldTableCell: UITableViewCell {

    @IBOutlet weak var detailTextField: UITextField!
}

class EditShiftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ShiftTimingViewControllerDelegate, ShiftLocationViewControllerDelegate, ShiftPositionViewControllerDelegate, ShiftEmployeeViewControllerDelegate, ShiftNotesViewControllerDelegate {

    let isCreateShift: Bool = true
    
    @IBOutlet weak var shiftTable: UITableView!
    @IBOutlet weak var actionButton: UIButton!
    
    var startAt: NSDate? = nil
    var endAt: NSDate? = nil
    var locationData: NSLocation? = nil
    var positionData: NSPosition? = nil
    var employeeArray: NSArray? = nil
    var shiftNotesStr: String = ""
    var isOpenShift: Bool = true
    var titleTextField: UITextField!
    
    var cellIdentifierArray = ["ShiftCell", "DateCell", "RepeatsCell", "LocationCell", "PositionCell", "OpenShiftCell", "ShiftNotesCell"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ShiftDetails")
        self.actionButton.setTitle(isCreateShift ? LocalizeHelper.sharedInstance.localizedStringForKey("CREATE_SHIFT") : LocalizeHelper.sharedInstance.localizedStringForKey("SAVE_CHANGES"), forState: UIControlState.Normal)
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let identifier = cellIdentifierArray[indexPath.row]
        if (identifier == "DateCell") {
            self.performSegueWithIdentifier(kShowShiftTimingVC, sender: self)
        } else if (identifier == "RepeatsCell") {
            self.performSegueWithIdentifier(kShowShiftRepeatVC, sender: self)
        } else if (identifier == "LocationCell") {
            self.performSegueWithIdentifier(kShowShiftLocationVC, sender: self)
        } else if (identifier == "PositionCell") {
            self.performSegueWithIdentifier(kShowShiftPositionVC, sender: self)
        } else if (identifier == "EmployeeCell") {
            self.performSegueWithIdentifier(kShowShiftEmployeeVC, sender: self)
        } else if (identifier == "ShiftNotesCell") {
            self.performSegueWithIdentifier(kShowShiftNotesVC, sender: self)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellIdentifierArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = self.cellIdentifierArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        
        cell.layer.borderWidth = 0.35
        cell.layer.borderColor = GRAY_COLOR_3.CGColor
        
        if (cell.isKindOfClass(DateTableCell)) {
            (cell as! DateTableCell).startsDescLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("Starts")
            (cell as! DateTableCell).endsDescLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("Ends")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mm aa | MMM dd, yyyy"
            if (startAt == nil) {
                (cell as! DateTableCell).startAtLabel.text = ""
            } else {
                (cell as! DateTableCell).startAtLabel.text = dateFormatter.stringFromDate(startAt!)
            }
            if (endAt == nil) {
                (cell as! DateTableCell).endAtLabel.text = ""
            } else {
                (cell as! DateTableCell).endAtLabel.text = dateFormatter.stringFromDate(endAt!)
            }
        } else if cellIdentifier == "RepeatsCell" {
            let textField = cell.viewWithTag(1) as! UITextField
            textField.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("Repeats")
        } else if cellIdentifier == "LocationCell" {
            let textField = cell.viewWithTag(1) as! UITextField
            textField.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("Location")
            
            if (locationData != nil) {
                (cell as! DetailWithTextFieldTableCell).detailTextField.text = locationData?.name
            } else {
                (cell as! DetailWithTextFieldTableCell).detailTextField.text = ""
            }
        } else if cellIdentifier == "PositionCell" {
            let textField = cell.viewWithTag(1) as! UITextField
            textField.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("Position")
            
            if (positionData != nil) {
                (cell as! DetailWithTextFieldTableCell).detailTextField.text = positionData?.name
            } else {
                (cell as! DetailWithTextFieldTableCell).detailTextField.text = ""
            }
        } else if cellIdentifier == "EmployeeCell" {
            let textField = cell.viewWithTag(1) as! UITextField
            textField.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("Employee")
            
            if (self.employeeArray != nil) {
                let nameArray = NSMutableArray()
                if (employeeArray?.count > 3) {
                    for i in 0...3 {
                        nameArray.addObject((self.employeeArray![i] as! NSEmployee).name)
                    }
                } else {
                    for employee in self.employeeArray! {
                        nameArray.addObject((employee as! NSEmployee).name)
                    }
                }
                let nameStr = nameArray.componentsJoinedByString(", ")
                (cell as! DetailWithTextFieldTableCell).detailTextField.text = employeeArray?.count > 3 ? nameStr+", 3 more" : nameStr
            } else {
                (cell as! DetailWithTextFieldTableCell).detailTextField.text = ""
            }
        } else if cellIdentifier == "ShiftCell" {
            let textField = cell.viewWithTag(1) as! UITextField
            textField.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("ShiftLabel")
            
            titleTextField = cell.viewWithTag(1) as! UITextField
            titleTextField.delegate = self
        } else if cellIdentifier == "ShiftNotesCell" {
            let label = (cell as! NSBasicTableViewCell).subtitleLabel
            if (shiftNotesStr.isEmpty) {
                label.text = LocalizeHelper.sharedInstance.localizedStringForKey("ShiftNotes")
            } else {
                label.text = shiftNotesStr
            }
        } else if cellIdentifier == "OpenShiftCell" {
            let descTextField = cell.viewWithTag(1) as! UITextField
            descTextField.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("This_is_an_Open_Shift")
            
            let openShiftSwitch = cell.viewWithTag(2) as! UISwitch
            openShiftSwitch.setOn(isOpenShift, animated: true)
            openShiftSwitch.addTarget(self, action: Selector("onChangeSwitch:"), forControlEvents: .ValueChanged)
        }
        
        return cell
    }
    
    //--------------------- Header ----------------------------//
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 30))
        headerView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        
        let descLabel = UILabel.init(frame: CGRectMake(10, 5, 150, 20))
        descLabel.text = isCreateShift ?
            LocalizeHelper.sharedInstance.localizedStringForKey("CREATE_A_SHIFT") :
            LocalizeHelper.sharedInstance.localizedStringForKey("EDIT_THIS_SHIFT")
        descLabel.font = Utilities.boldFontWithSize(12)
        descLabel.textColor = MAIN_COLOR
        descLabel.backgroundColor = UIColor.clearColor()
        headerView .addSubview(descLabel)
        
        headerView.layer.borderWidth = 0.7
        headerView.layer.borderColor = GRAY_COLOR_3.CGColor
        
        return headerView
    }

    //------------------- Seperator ----------------//
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    //------------------ Dynamic Cell Height --------------------------//
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (cellIdentifierArray[indexPath.row] == "ShiftNotesCell") {
            return max(80, self.heightWithCellAtIndexPath(indexPath))
        } else if (cellIdentifierArray[indexPath.row] == "DateCell") {
            return 80
        }
        return 44
    }
    
    // MARK: - UITableView Calc Height
    func heightWithCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        
        var sizingCell: UITableViewCell!
        var onceToken: dispatch_once_t = 0
        let identifier = cellIdentifierArray[indexPath.row]
        dispatch_once(&onceToken) { () -> Void in
            sizingCell = self.shiftTable.dequeueReusableCellWithIdentifier(identifier)
        }
        if (identifier == "ShiftNotesCell") {
            let label = (sizingCell as! NSBasicTableViewCell).subtitleLabel
            if (shiftNotesStr.isEmpty) {
                label.text = "Shift Notes"
            } else {
                label.text = shiftNotesStr
            }
        }
        return self.calculateHeightForConfiguredSizingCell(sizingCell)
    }
    
    func calculateHeightForConfiguredSizingCell(sizingCell: UITableViewCell) -> CGFloat {
        
        sizingCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.shiftTable.frame), CGRectGetHeight(sizingCell.bounds))
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size: CGSize = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height + 1
    }
    
    // MARK: - UIButton Action
    
    @IBAction func onClickAction(sender: AnyObject) {
        
        if isCreateShift {
            let idArray = NSMutableArray()
            if !isOpenShift {
                for employee in self.employeeArray! {
                    idArray.addObject((employee as! NSEmployee).ID)
                }
            }
            
            let repeatDict = [    "RepeatedShiftId": 0,
                "UpdateOneShiftOnly": true,
                "RepeatType": 1,
                "RepeatEndDate": "2016-01-08T09:20:10.234Z",
                "RepeatEndNever": true,
                "Monday": true,
                "Tuesday": true,
                "Wednesday": true,
                "Thursday": true,
                "Friday": true,
                "Saturday": true,
                "Sunday": true]
            
            NSAPIClient.sharedInstance.createShift(titleTextField.text!, startAt: Utilities.stringFromDate(startAt, isShortForm: false) as! String, endAt: Utilities.stringFromDate(endAt, isShortForm: false) as! String, repeatDict: repeatDict, locationId: self.locationData!.ID, positionId: self.positionData!.ID, employeeArray: idArray, isOpenShift: true, notes: shiftNotesStr, callback: { (nsData, error) -> Void in
                
                print(nsData)
            })
        }
    }
    
    // MARK: - UISwitch Handler
    func onChangeSwitch(sender: UISwitch) {
        
        isOpenShift = sender.on
        if isOpenShift {
            cellIdentifierArray = ["ShiftCell", "DateCell", "RepeatsCell", "LocationCell", "PositionCell", "OpenShiftCell", "ShiftNotesCell"]
            self.shiftTable.deleteRowsAtIndexPaths([NSIndexPath.init(forRow: 5, inSection: 0)], withRowAnimation: .Fade)
        } else {
            cellIdentifierArray = ["ShiftCell", "DateCell", "RepeatsCell", "LocationCell", "PositionCell", "EmployeeCell", "OpenShiftCell", "ShiftNotesCell"]
            self.shiftTable.insertRowsAtIndexPaths([NSIndexPath.init(forRow: 5, inSection: 0)], withRowAnimation: .Fade)
        }
        self.shiftTable.beginUpdates()
        self.shiftTable.endUpdates()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - ShiftTimingViewControllerDelegate
    func didSelectTimes(startDate: NSDate, endDate: NSDate) {
        
        startAt = startDate
        endAt = endDate
        
        shiftTable.reloadData()
    }
    
    // MARK: - ShiftLocationViewControllerDelegate
    func locationDidSelect(locationObj: NSLocation) {
        
        locationData = locationObj
        
        shiftTable.reloadData()
    }
    
    // MARK: - ShiftPositionViewControllerDelegate
    func positionDidSelect(positionObj: NSPosition) {
        
        positionData = positionObj
        
        shiftTable.reloadData()
    }
    
    // MARK: - ShiftEmployeeViewControllerDelegate
    func employeesDidSelect(employeeArray: NSArray) {
        
        self.employeeArray = employeeArray
        
        shiftTable.reloadData()
    }
    
    // MARK: - ShiftEmployeeViewControllerDelegate
    func shiftNotesDidSelect(shiftNotes: String) {
        
        shiftNotesStr = shiftNotes
        shiftTable.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == kShowShiftTimingVC) {
            let destVC = segue.destinationViewController as! ShiftTimingViewController
            destVC.delegate = self
        } else if segue.identifier == kShowShiftLocationVC {
            let destVC = segue.destinationViewController as! ShiftLocationViewController
            destVC.delegate = self
        } else if segue.identifier == kShowShiftPositionVC {
            let destVC = segue.destinationViewController as! ShiftPositionViewController
            destVC.delegate = self
        } else if segue.identifier == kShowShiftEmployeeVC {
            let destVC = segue.destinationViewController as! ShiftEmployeeViewController
            destVC.delegate = self
        } else if segue.identifier == kShowShiftNotesVC {
            let destVC = segue.destinationViewController as! ShiftNotesViewController
            destVC.shiftNotes = self.shiftNotesStr
            destVC.delegate = self
        }
    }

}
