//
//  EmployeeDetailViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 12/17/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

// Employee View Mode
enum EmployeeViewMode: Int {
    case employeeView = 0
    case employeeEdit // 1
    case employeeCreate
}

class PersonalInfoTableCell: UITableViewCell {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var avatarButton: UIButton!
    
    }

class ContactInfoTableCell: UITableViewCell {

    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    func disableAllInputField() {
    
    }
}

class LocAndPosTableCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var positionsLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    func processContent(locationId: String, positionId: String) {
        NSAPIClient.sharedInstance.getLocationDetailWithLocationId(locationId) { (nsData, error) -> Void in
            self.locationLabel.text = NSLocation.initWithDictionary(nsData as! NSDictionary)?.name
        }
        
        NSAPIClient.sharedInstance.getPositionDetailWithPositionId(positionId) { (nsData, error) -> Void in
            self.positionsLabel.text = NSPosition.initWithDictionary(nsData as! NSDictionary)?.name
        }
    }
}

class EmployeeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditLocAndPosViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var employeesTable: UITableView!
    @IBOutlet weak var toolViewHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolView: UIView!
    var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tableBtmConstraint: NSLayoutConstraint!
    
    var personalInfoCell: PersonalInfoTableCell? = nil
    var contactInfoCell: ContactInfoTableCell? = nil
    
    var viewMode: EmployeeViewMode = .employeeView // 0: ViewMode, 1: EditMode, 2:CreateMode
    var employeeData: NSEmployee? = nil
    var locationData: NSLocation? = nil
    var locAndPosArray = NSMutableArray()
    var calledApiCount = 0
    var deletedPosArray = NSMutableArray()
    
    let cellIdentifierArray = ["PersonalInfoCell", "ContactInfoCell", "AddLocAndPosCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        employeesTable.tableFooterView = UIView()
        
        self.editButton = UIBarButtonItem.init(image: UIImage.init(named: "ico-pencil"), style: .Plain, target: self, action: Selector("onClickEdit:"))
        
        self.updateContentUponViewMode(false)

        if viewMode == .employeeView {
            SVProgressHUD.show()

            NSAPIClient.sharedInstance.getEmployeeContactInfoWithEmployeeId((self.employeeData?.ID)!) { (nsData, error) -> Void in
                print(nsData)
                SVProgressHUD.dismiss()
                if error == nil {
                    self.employeeData?.updateWithContactInfo(nsData as! NSDictionary)
//                    let locationId = nsData!["locationId"] as? String
//                    if locationId != nil {
//                        SVProgressHUD.show()
//                        
//                        NSAPIClient.sharedInstance.getEmployeeContactInfoWithEmployeeId(locationId!, callback: { (nsData, error) -> Void in
//                            SVProgressHUD.dismiss()
//                            
//                            self.locationData = NSLocation.initWithDictionary(nsData as! NSDictionary)
//                            self.employeesTable.reloadData()
//                        })
//                    }
                    
                    self.employeesTable.reloadData()
                }
            }
            
            NSAPIClient.sharedInstance.getEmploymentListWithEmployeeId((self.employeeData?.ID)!, callback: { (nsData, error) -> Void in
                if error == nil {
                    let employmentArray = nsData!["data"] as! NSArray
                    self.locAndPosArray.addObjectsFromArray(employmentArray as [AnyObject])
                    self.employeesTable.reloadData()
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Utility Functions
    func updateContentUponViewMode(animated: Bool) {
        if viewMode == .employeeCreate { // Create Mode
            toolViewHeiConstraint.constant = 55
            toolView.hidden = false
            
            deleteButton.hidden = true
            applyButton.hidden = false
            
            self.navigationItem.rightBarButtonItem = nil
        } else if viewMode == .employeeView { // View Mode
            toolViewHeiConstraint.constant = 96
            toolView.hidden = false
            
            deleteButton.hidden = false
            applyButton.hidden = true
            
            self.navigationItem.rightBarButtonItem = self.editButton
        } else if viewMode == .employeeEdit { // Edit Mode
            toolViewHeiConstraint.constant = 55
            toolView.hidden = false
            
            deleteButton.hidden = true
            applyButton.hidden = false
            
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.employeesTable.reloadData()
        
        if (animated) {
            self.view.transform = CGAffineTransformMakeTranslation(SCRN_WIDTH, 0)
            UIView.animateWithDuration(0.5) { () -> Void in
                self.view.transform = CGAffineTransformMakeTranslation(0, 0)
            }
        }
    }
    
    // MARK: - API Call
    
    func createEmployeePositionWithPositionId(positionId: String, locationId: String) {
        NSAPIClient.sharedInstance.createEmployeePositionWithEmployeeId((self.employeeData?.ID)!, locationId: locationId, positionId: positionId) { (nsData, error) -> Void in
            if (error == nil) {
                if (++self.calledApiCount == self.locAndPosArray.count) {
                    Utilities.showMsg("Successfully created with all Locaitons and Positions.", delegate: self)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section != 2) {
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.width, 0, 15)
        } else {
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
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 2 {
            if locAndPosArray.count == indexPath.row {
                self.performSegueWithIdentifier(kShowEditLocAndPosVC, sender: self)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? viewMode == .employeeView ? locAndPosArray.count : locAndPosArray.count + 1 : 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return [119, 205, 60][indexPath.section]
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 33))
        headerView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        
        let descLabel = UILabel.init(frame: CGRectMake(10, 5, 250, 23))
        descLabel.text = ["PERSONAL INFO", "CONTACT INFO", "LOCATIONS AND POSITIONS"][section]
        descLabel.textColor = UIColor.darkGrayColor()
        descLabel.font = Utilities.fontWithSize(12.0)
        descLabel.backgroundColor = UIColor.clearColor()
        headerView .addSubview(descLabel)
        
        headerView.layer.borderColor = GRAY_COLOR_6.CGColor
        headerView.layer.borderWidth = 0.5
        
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = cellIdentifierArray[indexPath.section]
        if (indexPath.section == 2) {
            if (locAndPosArray.count > 0) {
                cellIdentifier = indexPath.row == locAndPosArray.count ? "AddAnotherCell" : "LocAndPosCell"
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        
        for subView in cell.contentView.subviews {
            if subView.isKindOfClass(UITextField) {
                (subView as! UITextField).delegate = self
            }
        }
        
        if (indexPath.section == 2) {
            if (locAndPosArray.count > 0 && indexPath.row < locAndPosArray.count) {
                let dict = locAndPosArray[indexPath.row]
                
                let locPosCell = cell as! LocAndPosTableCell
                
                locPosCell.closeButton.hidden = viewMode == .employeeView

                if Utilities.isValidData(dict["id"] as? String)  {
                    locPosCell.processContent(dict["locationId"] as! String, positionId: dict["positionId"] as! String)
                } else {
                    let locationData = dict["Location"] as! NSLocation
                    let positionArray = dict["Position"] as! NSArray
                    
                    let posNameArray = NSMutableArray()
                    for position in positionArray {
                        posNameArray.addObject((position as! NSPosition).name)
                    }
                    locPosCell.locationLabel.text = locationData.name
                    locPosCell.positionsLabel.text =  posNameArray.componentsJoinedByString(", ")
                }
                
                locPosCell.closeButton.addTarget(self, action: Selector("onClickPosDelete:"), forControlEvents: .TouchUpInside)
                locPosCell.closeButton.tag = indexPath.row
            }
        } else if (indexPath.section == 0) {
            personalInfoCell = cell as? PersonalInfoTableCell
            if self.employeeData != nil {
                personalInfoCell?.avatarButton.setBackgroundImageForState(.Normal, withURL: (self.employeeData?.avatarURL)!, placeholderImage: UIImage.init(named: "blueico_user"))
                personalInfoCell?.firstNameTextField.text = self.employeeData?.firstName
                personalInfoCell?.lastNameTextField.text = self.employeeData?.lastName
                personalInfoCell?.emailTextField.text = self.employeeData?.email
            }
            
        } else if (indexPath.section == 1) {
            contactInfoCell = cell as? ContactInfoTableCell
            if self.employeeData != nil {
                contactInfoCell?.countryTextField.text = self.employeeData?.country
                contactInfoCell?.address1TextField.text = self.employeeData?.addressLine1
                contactInfoCell?.address2TextField.text = self.employeeData?.addressLine2
                contactInfoCell?.cityTextField.text = self.employeeData?.city
                contactInfoCell?.zipTextField.text = self.employeeData?.zipCode
                contactInfoCell?.phoneTextField.text = self.employeeData?.mobile
            }
        }
        return cell
    }
    
    func onClickPosDelete(sender: UIButton) {
        deletedPosArray.addObject(locAndPosArray[sender.tag])
        locAndPosArray.removeObjectAtIndex(sender.tag)
        employeesTable.reloadData()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        tableBtmConstraint.constant = 8
        textField.resignFirstResponder()
        return true
    }
    
    func cellFromSubview(var subView: AnyObject) -> UITableViewCell {
        while subView.superview != nil {
            if ((subView.superview?!.isKindOfClass(UITableViewCell)) != nil) {
                return subView.superview?!.superview as! UITableViewCell
            } else {
                subView = (subView.superview as? AnyObject)!
            }
        }
        return UITableViewCell.init()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if viewMode == .employeeView {
            tableBtmConstraint.constant = 8
            return false
        }
        tableBtmConstraint.constant = 200
        return true
    }
    
    // MARK: - EditLocAndPosViewControllerDelegate
    func locAndPosDidEdit(positionDict: NSDictionary) {
        locAndPosArray.addObject(positionDict)
        employeesTable.reloadData()
    }

    // MARK: - UIButtonAction
    @IBAction func onClickDeleteEmployee(sender: AnyObject) {
        
        let alertVC = UIAlertController.init(title: kTitle_APP, message: "Delete \(self.employeeData!.name)?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (alert: UIAlertAction!) -> Void in
            SVProgressHUD.show()
            NSAPIClient.sharedInstance.deleteEmployeeWithEmployeeId((self.employeeData?.ID)!, callback: { (nsData, error) -> Void in
                SVProgressHUD.dismiss()
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
        let noAction = UIAlertAction(title: "No", style: .Default) { (alert: UIAlertAction!) -> Void in
            alertVC.dismissViewControllerAnimated(true, completion: nil)
        }
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func onClickEdit(sender: AnyObject) {
        
        viewMode = .employeeEdit
        self.updateContentUponViewMode(true)
    }
    
    @IBAction func onClickApply(sender: AnyObject) {
        
        // Validation check
        if !Utilities.isValidData(personalInfoCell?.firstNameTextField.text) {
            personalInfoCell?.firstNameTextField.layer.borderWidth = 1.0
            personalInfoCell?.firstNameTextField.layer.borderColor = UIColor.redColor().CGColor
            return
        } else {
            personalInfoCell?.firstNameTextField.layer.borderWidth = 0
        }
        
        // Internal function for update contact info
        func updateEmployeeContactInfo() {
            SVProgressHUD.show()
            NSAPIClient.sharedInstance.updateEmployeeContactInfoWithEmployeeId(self.employeeData!.ID, addressLine1: (self.contactInfoCell?.address1TextField.text)!, addressLine2: (self.contactInfoCell?.address2TextField.text)!, city: (self.contactInfoCell?.cityTextField.text)!, state: "", zipCode: (self.contactInfoCell?.zipTextField.text)!, mobile: (self.contactInfoCell?.phoneTextField.text)!, country: (self.contactInfoCell?.countryTextField.text)!, callback: { (nsData, error) -> Void in
                
                
                SVProgressHUD.dismiss()
            })
        }
        
        // Internal function for employee personal info update
        func updateEmployeePersonalInfo() {
            SVProgressHUD.show()
            NSAPIClient.sharedInstance.updateEmployeeWithEmployeeId(self.employeeData!.ID, firstName: (self.personalInfoCell?.firstNameTextField.text)!, lastName: (self.personalInfoCell?.lastNameTextField.text)!, email: (self.personalInfoCell?.emailTextField.text)!) { (nsData, error) -> Void in
                
                SVProgressHUD.dismiss()
                print(nsData)
            }
        }
        
        // Internal function for employee position create
        func createEmployeePositions() {
            var count = 0
            var calledCount = 0
            
            for dict in self.locAndPosArray {
                if !Utilities.isValidData(dict["id"] as? String)  {
                    let positionArray = dict["Position"] as! NSArray
                    count = count + positionArray.count
                }
            }
            
            // Create all added employee
            for dict in self.locAndPosArray {
                if !Utilities.isValidData(dict["id"] as? String)  {
                    let locationObj = dict["Location"] as! NSLocation
                    let positionArray = dict["Position"] as! NSArray
                    
                    for position in positionArray {
                        
                        NSAPIClient.sharedInstance.createEmployeePositionWithEmployeeId(self.employeeData!.ID, locationId: locationObj.ID, positionId: (position as! NSPosition).ID, callback: { (nsData, error) -> Void in
                            if (++calledCount == count) {
                                Utilities.showMsg("Successfully created with all Locaitons and Positions.", delegate: self)
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                            print(nsData)
                        })
                    }
                }
            }
        }
        
        // Internal Function for delete employee
        func deleteEmployeePosition() {
            for dict in self.deletedPosArray {
                if !Utilities.isValidData(dict["id"] as? String) {
                    let positionArray = dict["Position"] as! NSArray
                    
                    for position in positionArray {
                        
                        NSAPIClient.sharedInstance.deleteEmployeePositionWithPositionId((position as! NSPosition).ID, callback: { (nsData, error) -> Void in
                            
                        })
                    }
                } else {
                    NSAPIClient.sharedInstance.deleteEmployeePositionWithPositionId(dict["positionId"] as! String, callback: { (nsData, error) -> Void in
                        
                    })
                }
            }
            
            self.deletedPosArray.removeAllObjects()
        }
        
        if (viewMode == .employeeCreate) {
            SVProgressHUD.show()
            
            // Create Employee
            NSAPIClient.sharedInstance.createEmployee((personalInfoCell?.firstNameTextField.text)!, lastName: (personalInfoCell?.lastNameTextField.text)!, email: (personalInfoCell?.emailTextField.text)!, callback: { (nsData, error) -> Void in
                
                SVProgressHUD.dismiss()
                if error == nil {
                    print(nsData)
                    let employeeId = nsData!["UserName"] as? String
                    if employeeId != nil {
                        self.employeeData = NSEmployee.initWithDictionary(nsData! as! NSDictionary)
                        
                        updateEmployeeContactInfo() // Update Contact information
                    }
                } else {
                    Utilities.showMsg("Duplicated Username, Try again with different FirstName and LastName", delegate: self)
                }
                
                self.navigationController?.popViewControllerAnimated(true)
            })
        } else if viewMode == .employeeEdit {
            updateEmployeePersonalInfo()
            updateEmployeeContactInfo()
            createEmployeePositions()
            deleteEmployeePosition()
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == kShowEditLocAndPosVC {
            let destVC = segue.destinationViewController as! EditLocAndPosViewController
            destVC.delegate = self
        }
    }

}
