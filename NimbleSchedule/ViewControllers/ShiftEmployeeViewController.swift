//
//  ShiftEmployeeViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 11/16/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class ShiftEmployeeTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (selected) {
            self.checkButton.selected = selected
        } else {
            self.checkButton.selected = selected
        }
    }
}

protocol ShiftEmployeeViewControllerDelegate {
    func employeesDidSelect(employeeArray: NSArray)
}

class ShiftEmployeeViewController: UIViewController {
    private let cellIdentifier = "EmployeeCell"

    @IBOutlet weak var shiftEmployeeTable: UITableView!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    var delegate: ShiftEmployeeViewControllerDelegate? = nil
    var employeeArray = NSMutableArray()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeContent()
    }
    
    // MARK: - Localize
    func localizeContent() {
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ShiftEmployee")
        self.doneBarButton.title = LocalizeHelper.sharedInstance.localizedStringForKey("Done")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                self.shiftEmployeeTable.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickDone(sender: AnyObject) {
        
        let selEmployeeArray = NSMutableArray()
        for selIndexPath in shiftEmployeeTable.indexPathsForSelectedRows! {
            selEmployeeArray.addObject(employeeArray[selIndexPath.row])
        }
        if (selEmployeeArray.count > 0) {
            if self.delegate?.employeesDidSelect(selEmployeeArray) != nil {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return employeeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let employeeObj = employeeArray[indexPath.row] as! NSEmployee
        (cell as! ShiftEmployeeTableCell).nameLabel.text = employeeObj.name
        (cell as! ShiftEmployeeTableCell).avatarImageView.setImageWithURL(employeeObj.avatarURL, placeholderImage: UIImage.init(named: "blueico_user"))
        
        return cell
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
        
        return 60
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
