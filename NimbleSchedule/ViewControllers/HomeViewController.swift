//
//  HomeViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 10/27/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
   self.createShifts()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.sharedApplication().statusBarHidden = true
         SVProgressHUD.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        SVProgressHUD.dismiss()
    }
    //TEMPORARY
    func createShifts(){
        let shiftsArray = NSMutableArray()
        
        //monday
        let shift = NSSchedulePeriod()
        shift?.startAt = "6:30AM-13:00PM"
        shift?.employeeName = "Matt Chambers"
        shift?.employeePhoto = "https://nimble.blob.core.windows.net/photo-c0935ec1-1b47-4e38-a3b8-4a36fb1f7862/d0777eae-5a65-4656-9d97-4ff2210c0554"
        shift?.locationName = "San Diego HQ"
        shift?.positionName = "Customer Support"
        shift?.color = "#f11869"
        shift?.employeeAvailabilityStatus = "#f5d8e3"
        shift?.title = "Have fun"
        
        let shift1 = NSSchedulePeriod()
        shift1?.startAt = "7:30AM-14:00PM"
        shift1?.employeeName = "Ian Kaliman"
        shift1?.employeePhoto = "https://nimble.blob.core.windows.net/photo-c0935ec1-1b47-4e38-a3b8-4a36fb1f7862/ff84ad4e-43bd-4d7b-9684-52131ce45cff"
        shift1?.locationName = "San Diego HQ"
        shift1?.positionName = "Account Manager"
        shift1?.color = "#fb932e"
        shift1?.employeeAvailabilityStatus = "#e9dbcd"
        shift1?.title = "When does your shift end on Monday?"
        
        let shift2 = NSSchedulePeriod()
        shift2?.startAt = "6:30AM-13:00PM"
        shift2?.employeeName = "Zachary Chambers"
        shift2?.employeePhoto = "https://nimble.blob.core.windows.net/photo-c0935ec1-1b47-4e38-a3b8-4a36fb1f7862/03e0d715-6239-4fe3-b027-09373f500564"
        shift2?.locationName = "San Diego HQ"
        shift2?.positionName = "Customer Support"
        shift2?.color = "#53e114"
        shift2?.title = "Please call me as soon as you can"
        shift2?.employeeAvailabilityStatus = "#deebd9"
        
        let shift3 = NSSchedulePeriod()
        shift3?.startAt = "8:30AM-16:00PM"
        shift3?.employeeName = "Jennifer Cassedy"
        shift3?.employeePhoto = "https://nimble.blob.core.windows.net/photo-c0935ec1-1b47-4e38-a3b8-4a36fb1f7862/9cb5ae85-bedf-4e82-b9af-07a853966f16"
        shift3?.locationName = "San Diego HQ"
        shift3?.positionName = "Cashier"
        shift3?.color = "#13e0cf"
        shift3?.employeeAvailabilityStatus = "#cfe6e4"
        shift3?.title = "Can you please forward me the email from Michael?"
        
        shiftsArray.addObject(shift!)
        shiftsArray.addObject(shift1!)
        shiftsArray.addObject(shift2!)
        shiftsArray.addObject(shift3!)
        
        SharedDataManager.sharedInstance.temporaryData = shiftsArray
        
        
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
