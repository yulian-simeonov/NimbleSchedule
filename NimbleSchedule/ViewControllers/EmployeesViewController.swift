//
//  EmployeesViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 10/13/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit
import MessageUI

class EmployeesTableCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.statusButton != nil {
            if (selected) {
                self.statusButton.selected = selected
            } else {
                self.statusButton.selected = selected
            }
        }
    }
}

protocol EmployeesViewControllerDelegate {
    func employeesDidSelect(employeeArray: NSArray)
}

class EmployeesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MFMessageComposeViewControllerDelegate {

    private let cellIdentifier = "EmployeesCell"
    private let cellSelectIdentifier = "SelectEmployeesCell"
    
    @IBOutlet weak var employeesTable: UITableView!
    @IBOutlet weak var employeeSearchBar: UISearchBar!
    
    var delegate: EmployeesViewControllerDelegate? = nil
    
    var isFromLocation: Bool = false
    
    var employeeArray = NSMutableArray()
    var orgEmployeeArray = NSArray()
    var isEmployeeCreate: Bool = false
    var selIndex = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isFromLocation {
            let rightBarButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("onClickCreate:"))
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        
        self.employeeSearchBar.setShowsCancelButton(false, animated: false)
        self.populateList()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
          }
    
    func populateList(){
        SVProgressHUD.show()
        NSAPIClient.sharedInstance.getEmployeeList { (nsData, error) -> Void in
            print(nsData)
            SVProgressHUD.dismiss()
            if (error == nil) {
                self.employeeArray.removeAllObjects()
                for employeeDict in nsData!["data"] as! NSArray {
                    let employeeObj = NSEmployee.initWithDictionary(employeeDict as! NSDictionary)
                    if (employeeObj != nil) {
                        self.employeeArray.addObject(employeeObj!)
                    }
                }
                self.orgEmployeeArray = NSArray.init(array: self.employeeArray)
                self.employeesTable.reloadData()
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButtonAction
    
    @IBAction func onClickCreate(sender: AnyObject) {
        
        if isFromLocation {
            let selEmployeeArray = NSMutableArray()
            for selIndexPath in employeesTable.indexPathsForSelectedRows! {
                selEmployeeArray.addObject(employeeArray[selIndexPath.row])
            }
            if (selEmployeeArray.count > 0) {
                if self.delegate?.employeesDidSelect(selEmployeeArray) != nil {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        } else {
            isEmployeeCreate = true
            self.performSegueWithIdentifier(kShowEmployeeDetailVC, sender: self)
        }
    }
    
    // Mark: - UITableViewDataSource, UITableViewDelegate
    
    // Swipe to edit
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if isFromLocation {
            
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            selIndex = indexPath.row
            isEmployeeCreate = false
            self.performSegueWithIdentifier(kShowEmployeeDetailVC, sender: self)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
       // let employeeObj = employeeArray[indexPath.row] as! NSEmployee
        
        let text = UITableViewRowAction(style: .Normal, title: "Text") { action, index in
            self.launchMessageComposeViewController("0038163270746")
        }
        
        
        
        text.backgroundColor = GREEN_COLOR
        
        let call = UITableViewRowAction(style: .Normal, title: "Call") { action, index in
           self.dialNumber("0038163270746")
        }
        call.backgroundColor = GREEN_COLOR
        
        return [text, call]
    }
    
    //pragma sms and call
    
    func launchMessageComposeViewController(number : String) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.recipients = [number]
            messageVC.messageComposeDelegate=self;
            self.presentViewController(messageVC, animated: true, completion: nil)
        }
        else {
            print("User hasn't setup Messages.app")
        }
    }
    
    func dialNumber (number : String){
        let numberFormat = String(format: "%@%@", "tel:", number)
    UIApplication.sharedApplication().openURL(NSURL(string: numberFormat)!)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
          self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.isFromLocation ? tableView.dequeueReusableCellWithIdentifier(cellSelectIdentifier, forIndexPath: indexPath):  tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let employeeObj = employeeArray[indexPath.row] as! NSEmployee
        (cell as! EmployeesTableCell).nameLabel.text = employeeObj.name
        (cell as! EmployeesTableCell).emailLabel.text = employeeObj.email
        (cell as! EmployeesTableCell).avatarImageView.setImageWithURL(employeeObj.avatarURL, placeholderImage: UIImage.init(named: "blueico_user"))
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return employeeArray.count
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        let predicate = NSPredicate.init(format: "%K MATCHES[c] %@", "name", searchBar.text!)
//        let array = self.employeeArray.filteredArrayUsingPredicate(predicate)
        self.employeeArray.removeAllObjects()
        for employee in self.orgEmployeeArray {
            if (employee as! NSEmployee).name.lowercaseString.containsString(searchBar.text!.lowercaseString) {
                self.employeeArray.addObject(employee)
            }
        }
        searchBar.resignFirstResponder()
        self.employeesTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        self.employeeArray = NSMutableArray.init(array: self.orgEmployeeArray)
        self.employeesTable.reloadData()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.isEmpty==false){
        self.employeeArray.removeAllObjects()
        for employee in self.orgEmployeeArray {
            if (employee as! NSEmployee).name.lowercaseString.containsString(searchBar.text!.lowercaseString) {
                self.employeeArray.addObject(employee)
            }
        }
        }
        else{
        self.employeeArray.removeAllObjects()
            self.employeeArray=self.orgEmployeeArray.mutableCopy() as! NSMutableArray
        }
        self.employeesTable.reloadData()

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == kShowEmployeeDetailVC {
            let destVC = segue.destinationViewController as! EmployeeDetailViewController
            destVC.viewMode = isEmployeeCreate ? EmployeeViewMode.employeeCreate : EmployeeViewMode.employeeView // 0: ViewMode, 1: EditMode, 2:CreateMode
            if (!isEmployeeCreate) {
                destVC.employeeData = employeeArray[selIndex] as? NSEmployee
            }
        }
    }

}
