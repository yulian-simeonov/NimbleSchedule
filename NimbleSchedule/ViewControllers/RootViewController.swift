//
//  RootViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 10/9/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class RootViewController: JASidePanelController {

    override func viewDidLoad() {
        super.viewDidLoad()
   
      // Do any additional setup after loading the view.
        SharedDataManager.sharedInstance.rootVC = self;
        
        print(SharedDataManager.sharedInstance.isLoggedIn)
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as UIViewController
        self.centerPanel = viewController

        //HomeViewController
       // self.showTemporaryScreen()
        if (SharedDataManager.sharedInstance.isLoggedIn != true) {
            self.didLoggedOut()
        } else {
            NSAPIClient.authInstance.signIn(SharedDataManager.sharedInstance.userName, password: SharedDataManager.sharedInstance.password) { (nsData, error) -> Void in
                
                if ((error) != nil) {
                    print(error?.description)
                    
                    Utilities.showMsg("Login Failed", delegate: self)
                    
                    SharedDataManager.sharedInstance.removeUserInfo()
                    self.didLoggedOut()
                } else {
                    self.didLoggedIn()
                }
            }
            
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        
        self.leftPanel = self.storyboard?.instantiateViewControllerWithIdentifier("LeftNC")
        
    }

    func didLoggedOutWithAnimation() {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("WelcomeNC") as UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func didLoggedOut() {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("WelcomeNC") as UIViewController
        self.presentViewController(viewController, animated: false, completion: nil)
    }
    
    func showTemporaryScreen(){
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as UIViewController
        self.presentViewController(viewController, animated: false, completion: nil)
   
     }
    
    func didLoggedIn() {
        
        NSAPIClient.sharedInstance.getUserSettings { (nsData, error) -> Void in
            
            if nsData != nil {
               SharedDataManager.sharedInstance.fullName = Utilities.getValidString(nsData!["fullName"] as? String, defaultString: "None")
                SharedDataManager.sharedInstance.employeeId = Utilities.getValidString(nsData!["employeeId"] as? String, defaultString: "None")
                SharedDataManager.sharedInstance.timeZone = Utilities.getValidString(nsData!["timeZone"] as? String,defaultString:"None")
                SharedDataManager.sharedInstance.defaultLocation = Utilities.getValidString(nsData!["defaultLocation"]  as? String, defaultString: "None")
                SharedDataManager.sharedInstance.defaultTimezone = Utilities.getValidString(nsData!["defaultTimeZone"]  as? String, defaultString: "None")       
                SharedDataManager.sharedInstance.offset = nsData!["offset"] as! NSInteger
                SharedDataManager.sharedInstance.hasDepartments = nsData!["hasDepartments"] as! Bool
                SharedDataManager.sharedInstance.useRegionFiltering = nsData!["useRegionFiltering"] as! Bool
                SharedDataManager.sharedInstance.weekStartDay = nsData!["weekStartDay"] as! NSInteger
                
                SharedDataManager.sharedInstance.saveUserInfo()
            }
        }
        
        UIApplication.sharedApplication().statusBarHidden = false

        self.centerPanel = self.storyboard?.instantiateViewControllerWithIdentifier("DashboardNC")
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
