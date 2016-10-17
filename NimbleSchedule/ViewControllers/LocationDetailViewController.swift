//
//  LocationDetailViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 12/22/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class HoursOperationTableCell: UITableViewCell {

    @IBOutlet weak var satHourLabel: UILabel!
    @IBOutlet weak var sunHourLabel: UILabel!
    @IBOutlet weak var monHourLabel: UILabel!
    @IBOutlet weak var tueHourLabel: UILabel!
    @IBOutlet weak var wedHourLabel: UILabel!
    @IBOutlet weak var thuHourLabel: UILabel!
    @IBOutlet weak var friHourLabel: UILabel!

    
    func processContent(hoursOperationData: NSHoursOperation?) {
        
        func stringFromHoursOperationData(hoursData: NSHoursOperationDay) -> String{
            
            if (hoursData.closedOn) {
                return "Closed"
            }
            return "\(Utilities.stringFromDate(hoursData.startsTime, formatStr: "hh:mm aa")) - \(Utilities.stringFromDate(hoursData.endsTime, formatStr: "hh:mm aa"))"
        }
        
        if hoursOperationData != nil {
            self.satHourLabel.text = stringFromHoursOperationData(hoursOperationData!.satHours)
            self.sunHourLabel.text = stringFromHoursOperationData(hoursOperationData!.sunHours)
            self.monHourLabel.text = stringFromHoursOperationData(hoursOperationData!.monHours)
            self.tueHourLabel.text = stringFromHoursOperationData(hoursOperationData!.tueHours)
            self.wedHourLabel.text = stringFromHoursOperationData(hoursOperationData!.wedHours)
            self.thuHourLabel.text = stringFromHoursOperationData(hoursOperationData!.thuHours)
            self.friHourLabel.text = stringFromHoursOperationData(hoursOperationData!.friHours)
        }
    }
}

class GeneralInfoTableCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var timeZoneLabel : UILabel!
    @IBOutlet weak var primarySwitch : UISwitch!
    @IBOutlet weak var inactiveSwitch : UISwitch!
    @IBOutlet weak var timezoneButton : UIButton!
    @IBOutlet weak var primaryLabel : UILabel!
    @IBOutlet weak var inactiveLabel : UILabel!
    @IBOutlet weak var timezoneTextField : UITextField!
    @IBOutlet weak var stateTextField : UITextField!
    
    func processContent(locationData: NSLocation?) {
        if locationData != nil {
            self.countryTextField.text = locationData?.country
            self.address1TextField.text = locationData?.addressLine1
            self.address2TextField.text = locationData?.addressLine2
            self.cityTextField.text = locationData?.city
            self.zipTextField.text = locationData?.zipCode
            self.phoneTextField.text = locationData?.phone
            self.nameTextField.text = locationData?.name
            self.timezoneTextField.text = locationData?.timeZone
            self.primarySwitch.on=(locationData?.primary)!
            self.inactiveSwitch.on = (locationData?.inactive)!
            self.stateTextField.text = locationData?.state as? String

        }
        else{
            self.timezoneTextField.text = SharedDataManager.sharedInstance.timeZone
        }
        
        
        //localization
        self.nameTextField.placeholder = NSLocalizedString("Name of location", comment: "Name of location")
        self.countryTextField.placeholder = NSLocalizedString("County", comment: "Country")
        self.address1TextField.placeholder = NSLocalizedString("Address line 1", comment: "Address line 1")
        self.address2TextField.placeholder = NSLocalizedString("Address line 2", comment: "Address line 2")
        self.cityTextField.placeholder = NSLocalizedString("City", comment: "City")
        self.zipTextField.placeholder = NSLocalizedString("Zip", comment: "Zip")
        self.phoneTextField.placeholder = NSLocalizedString("Phone number", comment: "Phone number")
        self.timeZoneLabel.text = NSLocalizedString("Timezone", comment: "Timezone")
        self.primaryLabel.text = NSLocalizedString("Primary", comment: "Primary")
        self.inactiveLabel.text = NSLocalizedString("Inactive", comment: "Inactive")
        self.stateTextField.placeholder = NSLocalizedString("State", comment: "State")
        
        Utilities.capitalLetterTextField(self.countryTextField)
        Utilities.capitalLetterTextField(self.nameTextField)
        Utilities.capitalLetterTextField(self.address1TextField)
        Utilities.capitalLetterTextField(self.cityTextField)
        Utilities.capitalLetterTextField(self.address2TextField)
    }

    
}

class ManagerTableCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
}

class LocationDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, EmployeesViewControllerDelegate, HoursOfOperationViewControllerDelegate,SBPickerSelectorDelegate {
    
    @IBOutlet weak var locationsTable: UITableView!
    @IBOutlet weak var toolViewHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolView: UIView!
    var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tableBtmConstraint: NSLayoutConstraint!
    
    var generalInfoCell: GeneralInfoTableCell? = nil
    var hoursOperationCell: HoursOperationTableCell? = nil
    
    var viewMode: EmployeeViewMode = .employeeView // 0: ViewMode, 1: EditMode, 2:CreateMode
    var locationData: NSLocation?
    var hoursOperationData: NSHoursOperation?
    var managerArray = NSMutableArray()
   // var deletedManagerArray = NSMutableArray()
    var calledApiCount = 0
    var managerNames = NSMutableArray()
    var managerIds = NSMutableArray()
    var newManagersArray = NSMutableArray()
    var timeZones = NSMutableArray()
    var timezoneNames = NSMutableArray()
    var timezoneIds = NSMutableArray()
    var countryNames  = NSMutableArray()
    var countryIds = NSMutableArray()
    var stateNames  = NSMutableArray()
    var stateIds = NSMutableArray()
    
    var timezonePicker = SBPickerSelector()
    var countryPicker = SBPickerSelector()
    var statePicker = SBPickerSelector()
    
    let cellIdentifierArray = ["GeneralInfoCell", "HoursOperationCell", "ManagerCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationsTable.tableFooterView = UIView()
        
        self.editButton = UIBarButtonItem.init(image: UIImage.init(named: "ico-pencil"), style: .Plain, target: self, action: Selector("onClickEdit:"))
        self.deleteButton.setTitle(NSLocalizedString("DELETE THIS LOCATION", comment: "DELETE THIS LOCATION"), forState: UIControlState.Normal)
        self.applyButton.setTitle(NSLocalizedString("APPLY", comment: "APPLY"), forState: UIControlState.Normal)
        

   
        self.updateContentUponViewMode(false)
        
        if viewMode == .employeeView {
            self.refreshContent()
           self.getLocationManagers()
        }
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            self.initPickers()
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
            }
        }
        
        self.getTimeZones()
        self.getCountries()
  

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.hoursOperationData = SharedDataManager.sharedInstance.hours
        locationsTable.reloadData()

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.getStatesForId((self.generalInfoCell?.countryTextField.text)!)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK picker
    @IBAction func showTimezonePicker(){
        if(self.viewMode == .employeeCreate || self.viewMode == .employeeEdit){
                self.timezonePicker.showPickerOver(self)
         self.view.endEditing(true)
        }
    }
    
    @IBAction func showCountryPicker(){
        if(self.viewMode == .employeeCreate || self.viewMode == .employeeEdit){
         self.view.endEditing(true)
         self.countryPicker.showPickerOver(self)
        }
    }
    
    @IBAction func showStatePicker(){
        //find country id
        if(self.viewMode == .employeeCreate || self.viewMode == .employeeEdit){
         self.view.endEditing(true)
       self.statePicker.showPickerOver(self)
            }
    }
    
    func initPickers(){
        self.timezonePicker = SBPickerSelector.picker()
        self.timezonePicker.pickerType = SBPickerSelectorType.Text
        self.timezonePicker.onlyDayPicker = true
        self.timezonePicker.datePickerType = SBPickerSelectorDateType.OnlyHour
        self.timezonePicker.doneButton?.title = NSLocalizedString("Done", comment: "Done")
        self.timezonePicker.cancelButton?.title = NSLocalizedString("Cancel", comment: "Cancel")
        self.timezonePicker.pickerData = self.timezoneNames.copy() as! NSArray as [AnyObject]
        self.timezonePicker.delegate=self
        
        self.countryPicker = SBPickerSelector.picker()
        self.countryPicker.pickerType = SBPickerSelectorType.Text
        self.countryPicker.onlyDayPicker = true
        self.countryPicker.datePickerType = SBPickerSelectorDateType.OnlyHour
        self.countryPicker.doneButton?.title = NSLocalizedString("Done", comment: "Done")
        self.countryPicker.cancelButton?.title = NSLocalizedString("Cancel", comment: "Cancel")

        self.countryPicker.delegate=self
        
        
        self.statePicker = SBPickerSelector.picker()
        self.statePicker.pickerType = SBPickerSelectorType.Text
        self.statePicker.onlyDayPicker = true
        self.statePicker.datePickerType = SBPickerSelectorDateType.OnlyHour
        self.statePicker.doneButton?.title = NSLocalizedString("Done", comment: "Done")
        self.statePicker.cancelButton?.title = NSLocalizedString("Cancel", comment: "Cancel")
        
        self.statePicker.delegate=self

    }
    
    func getTimeZones(){
   // SVProgressHUD.show()
          NSAPIClient.sharedInstance.getTimeZones { (nsData, error) -> Void in
        //     SVProgressHUD.dismiss()
            if(error == nil){
            let timezones = nsData as! NSDictionary
              let timeZoneNames = timezones.objectForKey("data") as! NSArray
                self.timezoneNames = (timeZoneNames.valueForKey("name") as! NSArray).mutableCopy() as! NSMutableArray
                self.timezoneIds = (timeZoneNames.valueForKey("id") as! NSArray).mutableCopy() as! NSMutableArray
                self.timezonePicker.pickerData = self.timezoneNames as [AnyObject]
            }
            else{
            Utilities.showMsg(NSLocalizedString("Failed getting timezones", comment: "Failed getting timezones"), delegate: self)
            }
        }
    }
    
    func getCountries(){
    //SVProgressHUD.show()
        NSAPIClient.sharedInstance.getCountryList { (nsData, error) -> Void in
              // SVProgressHUD.dismiss()
            if(error == nil){
               let countriesData = nsData as! NSDictionary
               let countries = countriesData.objectForKey("data") as! NSArray
                self.countryNames = (countries.valueForKey("name") as! NSArray).mutableCopy() as! NSMutableArray
                self.countryIds = (countries.valueForKey("id") as! NSArray).mutableCopy() as! NSMutableArray
                self.countryPicker.pickerData = self.countryNames as [AnyObject]
            }
            else{
             Utilities.showMsg(NSLocalizedString("Failed getting countries", comment: "Failed getting countries"), delegate: self)
            self.getCountries()
            }
        }
        
    }
    func getStatesForId(id : String){
   //SVProgressHUD.show()
        NSAPIClient.sharedInstance.getStates(id) { (nsData, error) -> Void in
            //SVProgressHUD.dismiss()
            if(error == nil){
              let statesData = nsData as! NSDictionary
                let states = statesData.objectForKey("data") as! NSArray
                self.stateNames = (states.valueForKey("name") as! NSArray).mutableCopy() as! NSMutableArray
                self.stateIds = (states.valueForKey("id") as! NSArray).mutableCopy() as! NSMutableArray
                self.statePicker.pickerData = self.stateNames as [AnyObject]
            }
            else{
            
            }
        }
    }
    
    
    func pickerSelector(selector: SBPickerSelector!, selectedValue value: String!, index idx: Int) {
    //timezonePicker
        self.applyButton.setNeedsDisplay()
        if(selector == self.timezonePicker){
            self.timezoneNames.enumerateObjectsUsingBlock { (a : AnyObject,i : Int, stop :UnsafeMutablePointer<ObjCBool>) -> Void in
                if(self.timezoneNames.objectAtIndex(i) as! String == value){
                    stop.initialize(true)
                    self.generalInfoCell?.timezoneTextField.text = self.timezoneIds.objectAtIndex(i) as? String
                }
            }

        }
        else if (selector == self.countryPicker){
            self.countryNames.enumerateObjectsUsingBlock { (a : AnyObject,i : Int, stop :UnsafeMutablePointer<ObjCBool>) -> Void in
                if(self.countryNames.objectAtIndex(i) as! String == value){                  
                    self.generalInfoCell?.countryTextField.text = self.countryIds.objectAtIndex(i) as? String
                      stop.initialize(true)
                     self.getStatesForId((self.generalInfoCell?.countryTextField.text)!)
                }
            }

        }
        else {
            self.stateNames.enumerateObjectsUsingBlock { (a : AnyObject,i : Int, stop :UnsafeMutablePointer<ObjCBool>) -> Void in
                if(self.stateNames.objectAtIndex(i) as! String == value){
                    self.generalInfoCell?.stateTextField.text = self.stateIds.objectAtIndex(i) as? String
                    stop.initialize(true)
                }
            }

        }
    }
    
    // MARK: - UI Utility Functions
    func updateContentUponViewMode(animated: Bool) {
        self.locationsTable.reloadData()
        if viewMode == .employeeCreate { // Create Mode
            toolView.hidden = false
            deleteButton.hidden = true
            applyButton.hidden = false
            self.navigationController?.title = NSLocalizedString("Create", comment: "Create")
            self.navigationItem.rightBarButtonItem = nil
            self.generalInfoCell?.primarySwitch.enabled=false
            self.generalInfoCell?.inactiveSwitch.enabled=false
       

        } else if viewMode == .employeeView { // View Mode
            toolView.hidden = false
            deleteButton.hidden = false
            applyButton.hidden = true
            self.navigationController?.title = nil
            self.navigationItem.rightBarButtonItem = self.editButton
            self.generalInfoCell?.primarySwitch.enabled=false
            self.generalInfoCell?.inactiveSwitch.enabled=false

        } else if viewMode == .employeeEdit { // Edit Mode
            toolView.hidden = false
            
            deleteButton.hidden = true
            applyButton.hidden = false
            self.navigationController?.title = NSLocalizedString("Edit", comment: "Edit")
            self.navigationItem.rightBarButtonItem = nil
            self.generalInfoCell?.primarySwitch.enabled=false
            self.generalInfoCell?.inactiveSwitch.enabled=false
        }
        
        if (animated ) {
            /*self.view.transform = CGAffineTransformMakeTranslation(SCRN_WIDTH, 0)
            UIView.animateWithDuration(0.5) { () -> Void in
               // self.view.transform = CGAffineTransformMakeTranslation(0, 0)
            }*/
            if(viewMode == .employeeEdit){
            self.slideInFromRight(0.3, completionDelegate: nil)
            }
            else{
            self.slideInFromLeft(0.3, completionDelegate: nil)
            }
        }
    }
    //pragma animation 
    
    func slideInFromRight(duration: NSTimeInterval = 0.3, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromRight
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.toolView.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        self.locationsTable.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    func slideInFromLeft(duration: NSTimeInterval = 0.3, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.toolView.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        self.locationsTable.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    
    // MARK: - API Call
    
    func refreshContent() {
               SVProgressHUD.show()
        NSAPIClient.sharedInstance.getLocationDetailWithLocationId((self.locationData?.ID)!, callback: { (nsData, error) -> Void in
            
            SVProgressHUD.dismiss()
            
            if error == nil && nsData != nil {
                self.locationData = NSLocation.initWithDictionary(nsData as! NSDictionary)
                self.hoursOperationData = self.locationData?.hoursOperation
                SharedDataManager.sharedInstance.hours = self.hoursOperationData
                self.locationsTable.reloadData()
            }
        })
    }
    
    func getLocationManagers(){
    //SVProgressHUD.show()
        NSAPIClient.sharedInstance.getLocationManagers((self.locationData?.ID)!) { (nsData, error) -> Void in
          //  SVProgressHUD.dismiss()
            let dictionary = nsData as! NSDictionary
            let mutable = dictionary.mutableCopy() as! NSMutableDictionary
            let users = mutable.valueForKey("data") as! NSArray
            self.managerNames = (users.valueForKey("name") as! NSArray).mutableCopy() as! NSMutableArray
            self.managerIds = (users.valueForKey("employeeId") as! NSArray).mutableCopy() as! NSMutableArray
            self.managerArray.removeAllObjects()
            self.managerNames.enumerateObjectsUsingBlock({ (ob : AnyObject,i : Int,u : UnsafeMutablePointer<ObjCBool>) -> Void in
            let employee = NSEmployee()
                employee?.name = (self.managerNames[i] as? String)!
                employee?.ID = (self.managerIds[i] as? String)!
                self.managerArray.addObject(employee!)
                      self.locationsTable.reloadData()
           })
        
        }
        
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None
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
            if managerArray.count == indexPath.row {
                self.performSegueWithIdentifier(kShowEmployeesVC, sender: self)
            }
        } else if indexPath.section == 1 {
            if viewMode != .employeeView {
                if self.hoursOperationData == nil {
                    self.performSegueWithIdentifier(kShowHoursOperationVC, sender: self)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 2 ? viewMode == .employeeView ? managerArray.count : managerArray.count + 1 : 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 49;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var height = [400, 180, 60][indexPath.section]
        if (indexPath.section == 1) {
            height = self.hoursOperationData == nil ? 60 : 180
        }
        return CGFloat(height)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView = UIView.init(frame: CGRectMake(0, 8, tableView.frame.size.width, 33))
        headerView.backgroundColor = GRAY_COLOR
        
        let labelView = UIView.init(frame: CGRectMake(0, 16,  tableView.frame.size.width,33))
        labelView.backgroundColor = UIColor.whiteColor()
        let descLabel = UILabel.init(frame: CGRectMake(10, 5, 250, 23))
        descLabel.text = [NSLocalizedString("GENERAL INFO", comment: "GENERAL INFO"), NSLocalizedString("HOURS OF OPERATION", comment: "HOURS OF OPERATION"), NSLocalizedString("MANAGERS", comment: "MANAGERS")][section]
        descLabel.textColor = GREEN_COLOR
        descLabel.font = Utilities.fontWithSize(12.0)
        descLabel.backgroundColor = UIColor.whiteColor()
        labelView .addSubview(descLabel)
        headerView.addSubview(labelView)
        
        
        // Add Edit button in the right side of header view
        if section == 1 &&
        viewMode != .employeeView &&
        self.hoursOperationData != nil {
            let xPos = tableView.frame.size.width - 80 - 10
            let viewButton = UIButton.init(frame: CGRectMake(xPos, 16, 100, 33))
            viewButton.setTitle(NSLocalizedString("Edit", comment: "Edit"), forState: UIControlState.Normal)
            viewButton .setTitleColor(MAIN_COLOR, forState: UIControlState.Normal)
            viewButton.titleLabel?.textAlignment = NSTextAlignment.Right
            viewButton.titleLabel?.font = Utilities.fontWithSize(15.0)
            viewButton.addTarget(self, action: Selector("onClickHoursEdit:"), forControlEvents: .TouchUpInside)
            
            headerView.addSubview(viewButton)
        }
        
        labelView.layer.borderColor = GRAY_COLOR_6.CGColor
        labelView.layer.borderWidth = 0.5
        
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier = cellIdentifierArray[indexPath.section]
        if (indexPath.section == 2) {
            if (managerArray.count > 0) {
                cellIdentifier = indexPath.row == managerArray.count ? "AddAnotherCell" : "ManagerCell"
            } else {
                cellIdentifier = "AddManagerCell"
            }
        } else if (indexPath.section == 1) {
            cellIdentifier = self.hoursOperationData == nil ? "AddHoursCell" : "HoursOperationCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.contentView.layer.borderColor = GRAY_COLOR_6.CGColor
        cell.contentView.layer.borderWidth = 0.5
        for subView in cell.contentView.subviews {
            if subView.isKindOfClass(UITextField) {
                (subView as! UITextField).delegate = self
            }
        }
        
        if (indexPath.section == 2) {
            if (managerArray.count > 0 && indexPath.row < managerArray.count) {
                let managerCell = cell as? ManagerTableCell
                let manager = managerArray[indexPath.row] as! NSEmployee
                managerCell?.nameLabel.text = manager.name
                managerCell?.closeButton.tag=indexPath.row
                //show closeButton only on edit and create
            if(viewMode == .employeeEdit || viewMode == .employeeCreate){
           managerCell?.closeButton.hidden = false
            }else{
                    managerCell?.closeButton.hidden = true
                }
            }
                   
            
        } else if (indexPath.section == 0) {
            
            generalInfoCell = cell as? GeneralInfoTableCell
            generalInfoCell?.processContent(self.locationData)
        } else if (indexPath.section == 1) {
            
            hoursOperationCell = cell as? HoursOperationTableCell
            hoursOperationCell?.processContent(self.hoursOperationData)
        }
        //check if switch buttons should have action
        if(viewMode == .employeeView){
        self.generalInfoCell?.primarySwitch.enabled = false
        self.generalInfoCell?.inactiveSwitch.enabled = false
        }
        else{
            self.generalInfoCell?.primarySwitch.enabled = true
            self.generalInfoCell?.inactiveSwitch.enabled = true
        }
        
        return cell
    }
    
   @IBAction func onClickPosDelete(sender: UIButton) {

    if (viewMode == .employeeEdit ){
      //  deletedManagerArray.addObject(managerArray[sender.tag])
      
    let employee : NSEmployee = managerArray.objectAtIndex(sender.tag) as! NSEmployee
    self.removeManagers(employee.ID, index: sender.tag)
        print(sender.tag)
    }
    
    }
    // Call remove manager API
    func removeManagers(employeeId : String , index : NSInteger) {
        // var calledAPICount = 0
         SVProgressHUD.show()
        //  for manager in self.deletedManagerArray {
        NSAPIClient.sharedInstance.deleteManagerWithLocationId((self.locationData?.ID)!, employeeId: employeeId, callback: { (nsData, error) -> Void in
            SVProgressHUD.dismiss()
            if((error == nil)){
            print("removed")
                  self.managerArray.removeObjectAtIndex(index)
                    self.locationsTable.reloadData()
                NSNotificationCenter.defaultCenter().postNotificationName("RefreshLocations", object: nil)

            }
            else{
            print("failed")
                print(error)
            }
        
        })
        /*if (++calledAPICount == self.managerArray.count) {
        Utilities.showMsg("Successfully removed all managers", delegate: self)
        }*/
        //
        // }
    }
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       // tableBtmConstraint.constant = 8
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
          //  tableBtmConstraint.constant = 8
            return false
        }
      //  tableBtmConstraint.constant = 200
        return true
    }
    
    // MARK: - UIButtonAction
    @IBAction func onClickDeleteLocation(sender: AnyObject) {
        
        SVProgressHUD.show()
        NSAPIClient.sharedInstance.deleteLocationWithLocationId((self.locationData?.ID)!) { (nsData, error) -> Void in
            
            SVProgressHUD.dismiss()
            if(error == nil){
                NSNotificationCenter.defaultCenter().postNotificationName("RefreshLocations", object: nil)
            self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    @IBAction func onClickEdit(sender: AnyObject) {
        
        viewMode = .employeeEdit
        self.locationsTable.reloadData()
        self.updateContentUponViewMode(true)

    }
    func returnToViewMode (){
    viewMode = .employeeView
        self.locationsTable.reloadData()
        self.updateContentUponViewMode(true)
    }
    
    //switch action
    @IBAction func switchChangedInactive (sender : UISwitch){
        if(sender.on == true && generalInfoCell!.primarySwitch.on == true){
            generalInfoCell!.primarySwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func switchChangedPrimary (sender : UISwitch){
        if (sender.on == true && generalInfoCell!.primarySwitch.on == true){
            generalInfoCell!.inactiveSwitch.setOn(false, animated: true)
        }
        
    }
    
    @IBAction func onClickApply(sender: AnyObject) {
        
        // Call Create location API
        func createLocation() {
            SVProgressHUD.show()
            NSAPIClient.sharedInstance.createLocation((generalInfoCell?.nameTextField.text)!, country: (generalInfoCell?.countryTextField.text)!, addressLine1: (generalInfoCell?.address1TextField.text)!, addressLine2: (generalInfoCell?.address2TextField.text)!, city: (generalInfoCell?.cityTextField.text)!, zipCode: (generalInfoCell?.zipTextField.text)!, phoneNumber: (generalInfoCell?.phoneTextField.text)!, primary: (generalInfoCell?.primarySwitch.on)!, inactive: (generalInfoCell?.inactiveSwitch.on)!,timeZone : (generalInfoCell?.timezoneTextField.text)!,state : (generalInfoCell?.stateTextField.text)!) { (nsData, error) -> Void in
                
                SVProgressHUD.dismiss()
                if error == nil && nsData != nil {
                    self.locationData = NSLocation.initWithDictionary(nsData as! NSDictionary)
                    //   addManagers()
                    if(self.hoursOperationData != nil){
                    updateHours()
                    }
                    self.addManagers()
                      NSNotificationCenter.defaultCenter().postNotificationName("RefreshLocations", object: nil)
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else {
                    Utilities.showMsg("Failed creating location", delegate: self)
                }

            }
        }
        
  
        
        // Call Update location API
        func updateLocation() {
            SVProgressHUD.show()
            NSAPIClient.sharedInstance.updateLocationWithLocationId(self.locationData!.ID, name: (generalInfoCell?.nameTextField.text)!, country: (generalInfoCell?.countryTextField.text)!, addressLine1: (generalInfoCell?.address1TextField.text)!, addressLine2: (generalInfoCell?.address2TextField.text)!, city: (generalInfoCell?.cityTextField.text)!, zipCode: (generalInfoCell?.zipTextField.text)!, phoneNumber: (generalInfoCell?.phoneTextField.text)!,primary: (generalInfoCell?.primarySwitch.on)!,inactive: (generalInfoCell?.inactiveSwitch.on)!,timezone: (generalInfoCell?.timezoneTextField.text)!,state : (generalInfoCell?.stateTextField.text)!) { (nsData, error) -> Void in
                SVProgressHUD.dismiss()
                if(error == nil){
                 
                    //update data model
                    self.locationData?.name = (self.generalInfoCell?.nameTextField.text)!
                    self.locationData?.country = (self.generalInfoCell?.countryTextField.text)!
                    self.locationData?.state = (self.generalInfoCell?.stateTextField.text)!
                    self.locationData?.addressLine1 = (self.generalInfoCell?.address1TextField.text)!
                    self.locationData?.addressLine2 = (self.generalInfoCell?.address2TextField.text)!
                    self.locationData?.city = (self.generalInfoCell?.cityTextField.text)!
                    self.locationData?.zipCode = (self.generalInfoCell?.zipTextField.text)!
                    self.locationData?.phone = (self.generalInfoCell?.phoneTextField.text)!
                    self.locationData?.timeZone = (self.generalInfoCell?.timezoneTextField.text)!
                    self.locationData?.primary = (self.generalInfoCell?.primarySwitch.on)!
                    self.locationData?.inactive = (self.generalInfoCell?.inactiveSwitch.on)!
                    self.viewMode = .employeeView
                    if(self.hoursOperationData != nil){
                       updateHours()
                    }
                       self.addManagers()
                                        NSNotificationCenter.defaultCenter().postNotificationName("RefreshLocations", object: nil)
         
                }
                else{
                print("failed updating")
                }
                            }
        }
        

        
        // Update Hours of Operation
        func updateHours() {
            if (self.hoursOperationData != nil ){
            NSAPIClient.sharedInstance.updateHoursOfOperationWithLocationId((self.locationData?.ID)!, hoursOperationData: self.hoursOperationData!) { (nsData, error) -> Void in
            
                if(error == nil){
                self.locationData?.hoursOperation = self.hoursOperationData
                    NSNotificationCenter.defaultCenter().postNotificationName("RefreshLocations", object: nil)
                    self.updateContentUponViewMode(true)
                    self.refreshContent()
                }
                else{
                    self.updateContentUponViewMode(true)
                    self.refreshContent()
               Utilities.showMsg("Failed updating hours", delegate: self)
                }
                
            }
            }
        }
        
 
        
        if viewMode == .employeeCreate {
            // Validation check for required fields: Name, Country
            
            if !Utilities.isValidData(generalInfoCell?.nameTextField.text) {
                Utilities.putWarningStatus((generalInfoCell?.nameTextField)!)
                Utilities.shakeView((generalInfoCell?.nameTextField)!)
                               return
            }
            else{
            Utilities.removeWarningStatus((generalInfoCell?.nameTextField)!)
            }
            if !Utilities.isValidData(generalInfoCell?.countryTextField.text) {
                Utilities.putWarningStatus((generalInfoCell?.countryTextField)!)
                        Utilities.shakeView((generalInfoCell?.countryTextField)!)
                                              return
            }
            else{
                 Utilities.removeWarningStatus((generalInfoCell?.countryTextField)!)
            }
            if !Utilities.isValidData(generalInfoCell?.stateTextField.text) {
                Utilities.putWarningStatus((generalInfoCell?.stateTextField)!)
                        Utilities.shakeView((generalInfoCell?.stateTextField)!)
                
                              return
            }
            else{
                 Utilities.removeWarningStatus((generalInfoCell?.stateTextField)!)
            }
            if(self.validatePhone() == true){
            createLocation()
            }
        } else if viewMode == .employeeEdit {
            // Validation check for required fields: Name, Country
            if !Utilities.isValidData(generalInfoCell?.nameTextField.text) {
                Utilities.putWarningStatus((generalInfoCell?.nameTextField)!)
                return
            }
            if !Utilities.isValidData(generalInfoCell?.countryTextField.text) {
                Utilities.putWarningStatus((generalInfoCell?.countryTextField)!)
                return
            }
            
            Utilities.removeWarningStatus((generalInfoCell?.nameTextField)!)
            Utilities.removeWarningStatus((generalInfoCell?.countryTextField)!)
            
            if(self.validatePhone() == true){
            updateLocation()
            }
            //updateHours()
           // addManagers()
           // removeManagers()
        }
        
    }
    
    func onClickHoursEdit(sender: UIButton) {
        
        self.performSegueWithIdentifier(kShowHoursOperationVC, sender: self)
    }
    
    // MARK: - EmployeesViewControllerDelegate
    
    func employeesDidSelect(employeeArray: NSArray) {
        newManagersArray.removeAllObjects()
        newManagersArray.addObjectsFromArray(employeeArray as [AnyObject])
        self.managerArray.addObjectsFromArray(employeeArray as [AnyObject])
        locationsTable.reloadData()
    }
    
    // Call Add manager API
    func addManagers() {
        SVProgressHUD.show()
        var calledAPICount = 0
        for manager in self.newManagersArray {
            NSAPIClient.sharedInstance.addManagerWithLocationId((self.locationData?.ID)!, employeeId: (manager as! NSEmployee).ID, callback: { (nsData, error) -> Void in
                SVProgressHUD.dismiss()
                if (++calledAPICount == self.newManagersArray.count) {
                  //  Utilities.showMsg("Successfully added all managers", delegate: self)
                    self.newManagersArray.enumerateObjectsUsingBlock({ (o : AnyObject, i : Int, s : UnsafeMutablePointer<ObjCBool>) -> Void in
                        self.managerArray.addObject(self.newManagersArray.objectAtIndex(i))
                        self.locationsTable.reloadData()
                        NSNotificationCenter.defaultCenter().postNotificationName("RefreshLocations", object: nil)
                        print("manager added")

                    })
                  
                }
            })
        }
    }
    
    // MAR: - HoursOperationViewControllerDelegate
    func hoursOfOperationDidEdited(hoursOperationObj: NSHoursOperation) {
        //self.hoursOperationData = SharedDataManager.sharedInstance.hours
        //locationsTable.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == kShowEmployeesVC {
            let destVC = segue.destinationViewController as! EmployeesViewController
            destVC.isFromLocation = true
            destVC.delegate = self
        } else if segue.identifier == kShowHoursOperationVC {
            let destVC = segue.destinationViewController as! HoursOfOperationViewController
            if self.hoursOperationData != nil {
                destVC.hoursOperationData = self.hoursOperationData
            }
            destVC.delegate = self
        }
    }
    //nav button override
    override func navigationShouldPopOnBackButton() -> Bool {
        if(viewMode == .employeeEdit){
            viewMode = .employeeView
                 self.updateContentUponViewMode(true)
        return false
        }
        else{
            SharedDataManager.sharedInstance.hours = nil
        return true
        }
    }

    
    func validatePhone() -> Bool{
        if (Utilities.isStringValid(self.generalInfoCell?.phoneTextField.text)){
            if (Utilities.isValidNumber(self.generalInfoCell?.phoneTextField.text)){
            return true
            }
            else{
                Utilities.showMsg(NSLocalizedString("Please enter a valid phone number", comment: "Please enter a valid phone number"), delegate: self)
            return false
            }
        }
        else{
        return true
        }
    }
    
    
}
