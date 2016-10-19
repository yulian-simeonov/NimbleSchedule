//
//  LocationsViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 10/13/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private let cellIdentifier = "LocationsCell"
    
    @IBOutlet weak var locationsTable: UITableView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    var locationArray = NSMutableArray()
    var orgLocationArray = NSArray()
    var isLocationCreate: Bool = false
    var selIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
     self.locationSearchBar .setShowsCancelButton(false, animated: false)
        self.title = NSLocalizedString("Locations", comment: "Locations")
  self.getLocations()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshNotification:"),name :"RefreshLocations",object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
           }
    
    func refreshNotification(notification : NSNotification){
    self.getLocations()
    }
    
    func getLocations(){
        
        SVProgressHUD.show()
        NSAPIClient.sharedInstance.getLocationList { (nsData, error) -> Void in
            print(nsData)
            SVProgressHUD.dismiss()
            
            if (error == nil) {
                self.locationArray.removeAllObjects()
                for locationDict in nsData!["data"] as! NSArray {
                    let locationObj = NSLocation.initWithDictionary(locationDict as! NSDictionary)
                    if (locationObj != nil) {
                        self.locationArray.addObject(locationObj!)
                    }
                }
                
                self.orgLocationArray = NSArray.init(array: self.locationArray)
                self.locationsTable.reloadData()
            }
            else{
            Utilities.showMsg(NSLocalizedString("Failed getting locations", comment: "Failed getting locations"), delegate: self)
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButtonAction
    
    @IBAction func onClickCreate(sender: AnyObject) {
        
        isLocationCreate = true
        SharedDataManager.sharedInstance.hours = nil
        self.performSegueWithIdentifier(kShowLocationDetailVC, sender: self)
    }
    
    // Mark: - UITableViewDataSource, UITableViewDelegat
    
    // Swipe to edit
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selIndex = indexPath.row
        isLocationCreate = false
        self.performSegueWithIdentifier(kShowLocationDetailVC, sender: self)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let call = UITableViewRowAction(style: .Normal, title: "Call") { action, index in
            print("Tap pick up")
            self.dialNumber("0038163270746")
        }
        call.backgroundColor = GREEN_COLOR
        
        return [call]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let locationObj = locationArray[indexPath.row] as! NSLocation
        (cell as! NSBasicTableViewCell).titleLabel.text = locationObj.name
        (cell as! NSBasicTableViewCell).subtitleLabel.text = "Manager: \(locationObj.managerName)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locationArray.count
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //        let predicate = NSPredicate.init(format: "%K MATCHES[c] %@", "name", searchBar.text!)
        //        let array = self.employeeArray.filteredArrayUsingPredicate(predicate)
        self.locationArray.removeAllObjects()
        for location in self.orgLocationArray {
            if (location as! NSLocation).name.lowercaseString.containsString((searchBar.text?.lowercaseString)!) {
                self.locationArray.addObject(location)
            }
        }
        searchBar.resignFirstResponder()
        self.locationsTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text=""
        searchBar.setShowsCancelButton(false, animated: true)
        self.locationArray = NSMutableArray.init(array: self.orgLocationArray)
        self.locationsTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.isEmpty==false){
            self.locationArray.removeAllObjects()
            for location in self.orgLocationArray {
                if (location as! NSLocation).name.lowercaseString.containsString((searchBar.text?.lowercaseString)!) {
                    self.locationArray.addObject(location)
                }
            }
            self.locationsTable.reloadData()
        }
        else{
          self.locationArray.removeAllObjects()
            self.locationArray = self.orgLocationArray.mutableCopy() as! NSMutableArray
             self.locationsTable.reloadData()
        }
    }
    
    func dialNumber (number : String){
        let numberFormat = String(format: "%@%@", "tel:", number)
        UIApplication.sharedApplication().openURL(NSURL(string: numberFormat)!)
    }
    
    // MARK: - Navigation    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == kShowLocationDetailVC {
            let destVC = segue.destinationViewController as! LocationDetailViewController
            destVC.viewMode = isLocationCreate ? EmployeeViewMode.employeeCreate : EmployeeViewMode.employeeView // 0: ViewMode, 1: EditMode, 2:CreateMode
            if (!isLocationCreate) {
                destVC.locationData = locationArray[selIndex] as? NSLocation
                SharedDataManager.sharedInstance.hours = destVC.locationData?.hoursOperation
            }
        }
    }
    
}
