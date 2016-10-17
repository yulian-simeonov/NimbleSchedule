//
//  SideMenuViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 10/12/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let cellsArray: [String] = ["DashboardCell", "ScheduleCell", "ClockCell", "RequestsCell", "MyAvailCell", "TimesheetsCell", "MessagesCell", "EmployeesCell", "LocationsCell"]
    
    @IBOutlet weak var menuTable: UITableView?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarHidden = true

        // Do any additional setup after loading the view.
        NSAPIClient.sharedInstance.getUserSettings { (nsData, error) -> Void in
            if nsData != nil {
                self.nameLabel.text = Utilities.getValidString(nsData!["fullName"] as? String, defaultString: "None")
                self.emailLabel.text = Utilities.getValidString(nsData!["userName"] as? String, defaultString: "None")
                let avatarUrl = NSURL.init(string: Utilities.getValidString(nsData!["photo"] as? String, defaultString: ""))
                self.avatarImageView.setImageWithURL(avatarUrl!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return cellsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellsArray[indexPath.row])!
        
        let titleLabel = cell.viewWithTag(1) as? UILabel
        if titleLabel != nil {
            let langKeys = ["Dashboard", "Schedule", "RequestsAndApprovals", "ClockInOut", "MyAvailability", "Timesheets", "Messages", "Employees", "Locations"]
            titleLabel?.text = LocalizeHelper.sharedInstance.localizedStringForKey(langKeys[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var storyboardID: String = "DashboardNC"
        switch(indexPath.row) {
        case 0:
            storyboardID = "DashboardNC"
            break
        case 1:
            storyboardID = "ScheduleNC"
            break
        case 2:
            storyboardID = "ClockNC"
            break
        case 3:
            storyboardID = "RequestsNC"
            break
        case 4:
            storyboardID = "MyAvailNC"
            break
        case 5:
            storyboardID = "TimesheetsNC"
            break
        case 6:
            storyboardID = "MessagesNC"
            break
        case 7:
            storyboardID = "EmployeesNC"
            break
        case 8:
            storyboardID = "LocationsNC"
            break
        default:
            break
            
        }
        if (indexPath.row == 1) {
            SharedDataManager.sharedInstance.rootVC.centerPanel = UIStoryboard.init(name: "Schedule", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(storyboardID)
        } else {
            SharedDataManager.sharedInstance.rootVC.centerPanel = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardID)
        }
    }

    
    @IBAction func logOut(){
        let alertVC = UIAlertController.init(title: kTitle_APP, message: NSLocalizedString("Are you sure you want to log out?", comment: "Are you sure you want to log out?"), preferredStyle: UIAlertControllerStyle.Alert)
        
        let defaultAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .Default) { (alert: UIAlertAction!) -> Void in
           self.logOutSession()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (alert: UIAlertAction!) -> Void in
          alertVC.dismissViewControllerAnimated(true, completion: { () -> Void in
            
          })
        }
        alertVC.addAction(defaultAction)
        alertVC.addAction(cancelAction)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
        
     }
    
    func logOutSession(){
       SharedDataManager.sharedInstance.rootVC.toggleLeftPanel(nil)
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "IsLoggedIn")
        SharedDataManager.sharedInstance.accessToken="expired"
        
        SharedDataManager.sharedInstance.rootVC.didLoggedOutWithAnimation()

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
