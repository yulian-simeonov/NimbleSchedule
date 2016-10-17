//
//  ClockOutViewController.swift
//  NimbleSchedule
//
//  Created by Yosemite on 11/19/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit
import CoreLocation

class ClockOutViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var timerView: NSBorderedView!
    
    @IBOutlet weak var clockOutViewHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var clockOutView: UIView!
    @IBOutlet weak var clockOutButton: NSLoadingButton!
    
    @IBOutlet weak var timerViewHeiConstraint: NSLayoutConstraint!
    @IBOutlet weak var positionLabelHeiConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var lastClockInLabel: UILabel!
    @IBOutlet weak var totalSpentLabel: UILabel!
    
    @IBOutlet weak var lastClockInDescLabel: UILabel!
    @IBOutlet weak var totalSpentDescLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var slideButton: UIButton!
    
    var clockInDate: NSDate!
    var positionDict: NSDictionary!
    var clockInId: String!

    @IBOutlet weak var notesTextView: NSPlaceholderTextView!
    
    var timer: NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var frame = contentView.frame
        frame.size.width = SCRN_WIDTH
        contentView.frame = frame
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.bounds.size
        
        
        // Check TimeClockIn State and get StartClockInTime
        NSAPIClient.sharedInstance.getTimeClockState { (nsData, error) -> Void in
            print(nsData)
            let state = nsData!["state"] as! Bool
            if (state) {
                self.clockInDate = Utilities.dateFromString(nsData!["startTime"] as? String, isShortForm: false)
                if (self.clockInId == nil) {
                    self.clockInId = Utilities.getValidString(nsData!["clockInId"] as? String, defaultString: "")
                }
                self.updateContent()
            } else {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        SharedDataManager.sharedInstance.locationManager.delegate = self

        self.updateTimeView()
        self.updateContent()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerHandler"), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
        timer = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Localize
    func localizeContent() {
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ClockOut")
        self.lastClockInDescLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("Last_clock_in")
        self.totalSpentDescLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("Total_time_spent")
        self.notesTextView.placeholder = LocalizeHelper.sharedInstance.localizedStringForKey("Add_shift_notes")
    self.clockOutButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("CLOCK_OUT"), forState: .Normal)
        self.orLabel.text = LocalizeHelper.sharedInstance.localizedStringForKey("OR")
        self.slideButton.setTitle("SLIDE_TO_START_BREAK", forState: .Normal)
    }
    
    // MARK: - UI Function
    func updateContent() {
        positionLabel.text = Utilities.getValidString(positionDict["name"] as? String, defaultString: "None")
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "h:mmaa | MMM dd, yyyy"
        lastClockInLabel.text = dateformatter.stringFromDate(self.clockInDate)
        
        let timeInterval = NSDate().timeIntervalSinceDate(clockInDate)
        let hours = Int(timeInterval / 3600)
        let mins = Int((timeInterval - Double(hours * 3600)) / 60)
        totalSpentLabel.text = "\(hours) hours \(mins) minutes"
    }
    
    func updateTimeView() {
        let curDate = NSDate()
        let dateformatter = NSDateFormatter.init()
        
        dateformatter.dateFormat = "h:mm"
        self.timeLabel.text = dateformatter.stringFromDate(curDate)
        
        dateformatter.dateFormat = "aa"
        self.ampmLabel.text = dateformatter.stringFromDate(curDate).uppercaseString
        
        dateformatter.dateFormat = "MMMM dd, yyyy"
        self.dateLabel.text = dateformatter.stringFromDate(curDate)
        
        dateformatter.dateFormat = "s"
        self.secLabel.text = dateformatter.stringFromDate(curDate)
    }
    
    func timerHandler() {
        self.updateContent()
        self.updateTimeView()
    }
    
    // MARK: - UIButtonAction
    
    @IBAction func onClickSlide(sender: UIButton) {
        if (sender.selected) {
            sender.selected = false
            self.showClockOutView()
        } else {
            sender.selected = true
            self.hideClockOutView()
        }
    }
    
    @IBAction func onClickClockOut(sender: NSLoadingButton) {
        if !Utilities.isLocationServiceEnabled() {
            Utilities.showMsg("Location Service is disabled. Please allow this first and clock out", delegate: self)
        } else {
            sender.loading = true
            sender.setActivityIndicatorAlignment(NSLoadingButtonAlignmentCenter)
            SharedDataManager.sharedInstance.locationManager.startUpdatingLocation()
            
            self.performSelector(Selector("callClockOutAPI"), withObject: nil, afterDelay: 3)
        }
    }
    
    // MARK: - UI Functions
    func hideClockOutView() {
        self.contentView.backgroundColor = UIColor.darkGrayColor()
        self.timerView.backgroundColor = UIColor.init(red: 28/255.0, green: 28/255.0, blue: 28/255.0, alpha: 1.0)
        
        self.positionLabelHeiConstraint.constant = 0
        self.timerViewHeiConstraint.constant = 236 - 40
        self.clockOutViewHeiConstraint.constant = 0
        self.clockOutView.hidden = true
    }
    
    func showClockOutView() {
        self.contentView.backgroundColor = GRAY_COLOR_7
        self.timerView.backgroundColor = UIColor.whiteColor()
        
        self.positionLabelHeiConstraint.constant = 40
        self.timerViewHeiConstraint.constant = 236
        self.clockOutViewHeiConstraint.constant = 243
        self.clockOutView.hidden = false
    }
    
    // MARK: - API call
    func callClockOutAPI() {
        let locValue = SharedDataManager.sharedInstance.locationManager.location?.coordinate
        if (locValue == nil) {
            Utilities.showMsg("App doesn't fetch the location. Please try again", delegate: self)
            self.clockOutButton.loading = false
            return
        }
        
        NSAPIClient.sharedInstance.clockOutWithClockInId(self.clockInId, latitude: locValue!.latitude, longitude: locValue!.longitude) { (nsData, error) -> Void in
            self.clockOutButton.loading = false
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        SharedDataManager.sharedInstance.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.description)
        clockOutButton.loading = false
        
        Utilities.showMsg("Failed to fetch your location. Please try again!", delegate: self)
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
