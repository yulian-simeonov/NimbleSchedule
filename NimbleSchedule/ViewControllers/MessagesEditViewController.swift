//
//  MessagesEditViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 10/13/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class MessagesEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let cellIdentifier = "MessageSelectCell"
    
    @IBOutlet weak var employeesTable: UITableView!
    
    var isSelecting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButton Action
    
    @IBAction func onClickCancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        
        return cell
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
