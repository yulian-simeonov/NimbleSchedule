//
//  TimesheetsViewController.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 10/13/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class TimesheetsBarChartCell: UITableViewCell {
    
    @IBOutlet weak var barChart: PNBarChart!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
//        barChart.yValueMax = 30
        barChart.yMinValue = 0
        barChart.yMaxValue = 30

        self.barChart.yChartLabelWidth = 20.0
        self.barChart.chartMarginLeft = 30.0
        self.barChart.chartMarginRight = 10.0;
        self.barChart.chartMarginTop = 10
        self.barChart.chartMarginBottom = 15.0;
        self.barChart.labelMarginTop = 5.0;
        
        self.barChart.yLabelSuffix = "lv"
        
        barChart.xLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
//        barChart.yLabels = ["1 lv", "2 lv", "3 lv", "4 lv", "5 lv", "6 lv", "7 lv"]
        barChart.yValues = [3, 10, 30, 20, 0, 15, 0]

        self.barChart.showChartBorder = true
        self.barChart.isGradientShow = false
        self.barChart.isShowNumbers = false
        

        barChart.strokeChart()
    }
}

class TimesheetsPieChartCell: UITableViewCell {
    
    @IBOutlet weak var pieChart: PNPieChart!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let items = [PNPieChartDataItem.init(value: 30, color: LIGHTBLUE_COLOR),
        PNPieChartDataItem.init(value: 30, color: NAVY_COLOR),
        PNPieChartDataItem.init(value: 30, color: PINK_COLOR)]
        
        pieChart.hideValues = true
//        pieChart.outerCircleRadius = 15
        pieChart.updateChartData(items)
        
        pieChart.strokeChart()
    }
}

class TimesheetsDetailCell: UITableViewCell {
    
}

class TimesheetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var timesheetsTable: UITableView!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()
        
        let tblView =  UIView(frame: CGRectZero)
        timesheetsTable.tableFooterView = tblView
        timesheetsTable.tableFooterView!.hidden = true
        timesheetsTable.backgroundColor = UIColor.clearColor()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSegmentChange(sender: AnyObject) {
        
        self.timesheetsTable.reloadData()
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return typeSegment.selectedSegmentIndex == 0 ? 80 : [115, 220, 184][indexPath.section]
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return typeSegment.selectedSegmentIndex == 0 ? 0 : 15.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return typeSegment.selectedSegmentIndex == 0 ? 33.0 : 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 33))
        headerView.backgroundColor = GRAY_COLOR_3
        
        let descLabel = UILabel.init(frame: CGRectMake(20, 0, 200, 33))
        descLabel.text = "September 23, 2015"
        descLabel.font = Utilities.fontWithSize(17)
        descLabel.textColor = UIColor.whiteColor()
        descLabel.backgroundColor = UIColor.clearColor()
        descLabel.textAlignment = .Center
        descLabel.center = headerView.center
        headerView .addSubview(descLabel)
        
        headerView.layer.borderWidth = 0.7
        headerView.layer.borderColor = GRAY_COLOR_3.CGColor
        
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = typeSegment.selectedSegmentIndex == 0 ? "DetailCell" : ["ShiftClockCell", "BarChartCell", "PieChartCell"][indexPath.section]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.layer.borderColor = GRAY_COLOR_4.CGColor
        cell.layer.borderWidth = 0.7
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if typeSegment.selectedSegmentIndex == 0 {
            self.performSegueWithIdentifier(kShowShiftDetailVC, sender: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation be fore navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
