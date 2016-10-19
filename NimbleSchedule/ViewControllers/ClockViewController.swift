    //
//  ClockViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 10/13/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ClockViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var clockInButton: NSLoadingButton!
    
    var curLocation: CLLocationCoordinate2D!
    
    var timer: NSTimer!
    
    var clockInDate: NSDate!
    var clockInId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = GRAY_COLOR_3.CGColor
        
        SharedDataManager.sharedInstance.locationManager.requestAlwaysAuthorization()
        SharedDataManager.sharedInstance.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check ClockIn State if true, move to ClockOut View,
        NSAPIClient.sharedInstance.getTimeClockState { (nsData, error) -> Void in
            print(nsData)
            let state = nsData!["state"] as! Bool
            if (state) {
                self.clockInDate = Utilities.dateFromString(nsData!["startTime"] as! String, isShortForm: false)
                self.clockInId = Utilities.getValidString(nsData!["clockInId"] as? String, defaultString: "")
                self.flipView()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        SharedDataManager.sharedInstance.locationManager.delegate = self

        if !Utilities.isLocationServiceEnabled() {
            SharedDataManager.sharedInstance.locationManager.requestWhenInUseAuthorization()
        } else {
            SharedDataManager.sharedInstance.locationManager.startUpdatingLocation()
        }

        self.updateTimeView()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimeView"), userInfo: nil, repeats: true)
        
        // Localization
        self.localizeContent()
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
        
        self.title = LocalizeHelper.sharedInstance.localizedStringForKey("ClockIn")
        self.clockInButton.setTitle(LocalizeHelper.sharedInstance.localizedStringForKey("CLOCK_IN"), forState: .Normal)
    }
    
    // MARK: - UIButtonAction
    @IBAction func onClickClockIn(sender: NSLoadingButton) {
        
        if (Utilities.isLocationServiceEnabled()) {
            sender.loading = true
            sender.setActivityIndicatorAlignment(NSLoadingButtonAlignmentCenter)
            
            NSAPIClient.sharedInstance.getTimeClockState { (nsData, error) -> Void in
                print(nsData)
                let state = nsData!["state"] as! Bool
                if (state) {
                    sender.loading = false
                    
                    self.clockInDate = Utilities.dateFromString(nsData!["startTime"] as! String, isShortForm: false)
                    self.flipView()
                } else {
                    if (SharedDataManager.sharedInstance.locationManager.location == nil) {
                        Utilities.showMsg("Your location is not updated. Please try again", delegate: self)
                        SharedDataManager.sharedInstance.locationManager.startUpdatingLocation()
                    } else {
                        self.curLocation = SharedDataManager.sharedInstance.locationManager.location?.coordinate
                        NSAPIClient.sharedInstance.clockInWithEmploymentId(SharedDataManager.sharedInstance.employeeId, latitude: self.curLocation.latitude, longitude:self.curLocation.longitude) { (nsData, error) -> Void in
                            print(nsData)
                            
                            sender.loading = false
                            self.clockInDate = NSDate()
                            
                            self.flipView()
                        }
                    }
                }
            }
        } else {
            Utilities.showMsg("Location Service is disabled. Please allow this first and clock in", delegate: self)
        }
    }
    
    // MARK: - UI Function
    func flipView() {
        
        UIView.transitionWithView((self.navigationController?.view)!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            self.performSegueWithIdentifier(kShowClockInAsVC, sender: self)
            }) { (finished) -> Void in
                
        }
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
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        SharedDataManager.sharedInstance.locationManager.stopUpdatingLocation()
        print(manager.location)
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        locValue.latitude = 33.7489954
        locValue.longitude = -84.3879824
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let pin = MKPointAnnotation()
        pin.coordinate = locValue
        mapView.addAnnotation(pin)
        
        let locationSpan = MKCoordinateSpan.init(latitudeDelta: 100, longitudeDelta: 100)
        var region = MKCoordinateRegionMake(locValue, locationSpan)
        region.span.longitudeDelta = 0.004
        region.span.latitudeDelta = 0.004
        mapView.setRegion(region, animated: true)
        
        
        curLocation = locValue
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("AnnotationView")
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "AnnotationView")
            (annotationView as! MKPinAnnotationView).pinTintColor = UIColor.greenColor()
        }
        
        return annotationView
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == kShowClockInAsVC) {
            let destVC = segue.destinationViewController as! ClockInAsViewController
            destVC.clockInDate = clockInDate
            destVC.clockInId = self.clockInId
        }
    }

}
