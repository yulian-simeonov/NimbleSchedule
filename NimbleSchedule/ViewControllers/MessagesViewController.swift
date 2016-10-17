//
//  MessagesViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 10/13/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class MessageTableCell: UITableViewCell {
    
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

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let cellIdentifier = "MessageCell"
    private let selectCellIdentifier = "MessageSelectCell"
    
    @IBOutlet weak var employeesTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tblView =  UIView(frame: CGRectZero)
        employeesTable.tableFooterView = tblView
        employeesTable.tableFooterView!.hidden = true
        employeesTable.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButton Action
    
    @IBAction func onClickSelect(sender: AnyObject) {
    }
    
    @IBAction func onClickCreate(sender: AnyObject) {
        
    }
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(kShowMessageDetailVC, sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let name = cell.contentView.viewWithTag(1) as? UILabel
        let image = cell.contentView.viewWithTag(2) as? UIImageView
        let message = cell.contentView.viewWithTag(3) as? UILabel
        
        let period = SharedDataManager.sharedInstance.temporaryData.objectAtIndex(indexPath.row) as! NSSchedulePeriod
        
        name?.text = period.employeeName
        image?.sd_setImageWithURL(NSURL.init(string: period.employeePhoto))
        if(indexPath.row>0){
        message?.text = period.title
        }
        
        return cell
    }
    
    // Swipe to edit
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let call = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            print("Tap delete")
        }
        
        call.backgroundColor = RED_COLOR
        
        return [call]
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == kShowMessageDetailVC {
            let destVC = segue.destinationViewController as! MessageCreateViewController
            destVC.isCreate = false
        } else if segue.identifier == kShowMessageCreateVC {
            let destVC = segue.destinationViewController as! MessageCreateViewController
            destVC.isCreate = true
        }
    }
    
}
