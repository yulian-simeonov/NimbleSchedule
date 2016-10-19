//
//  MyScheduleView.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 11/26/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

protocol NSMyScheduleViewDelegate {
    func shiftDidSelect(shiftObj: NSShift)
}

class NSMyScheduleView: UIView, UIGestureRecognizerDelegate {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var delegate: NSMyScheduleViewDelegate?
    
    let rightPadding = 10 as CGFloat!
    let topPadding = 50 as CGFloat!
    let stepHei = 60 as CGFloat!
    let labelWid = 50 as CGFloat!
    
    var containerScrollView: UIScrollView!
    
    var shiftArray: NSMutableArray!
    
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func drawLine() {
        let leftPadding:CGFloat = 10.0
        let lineWid = CGFloat(self.bounds.size.width - labelWid - leftPadding - (rightPadding*2) )

        if ((shiftArray) != nil) {
            shiftArray.removeAllObjects()
        } else {
            shiftArray = NSMutableArray()
        }
        
        if (containerScrollView != nil) {
            containerScrollView.subviews.forEach({ $0.removeFromSuperview() })
        } else {
            
            containerScrollView = UIScrollView.init(frame: self.bounds)
            containerScrollView.showsVerticalScrollIndicator = false
            containerScrollView.contentSize = CGSizeMake(self.bounds.size.width, stepHei*24+topPadding)
            self.addSubview(containerScrollView)
        }
        
        
        
        let timelineView = UIView.init(frame: CGRectMake(0, 0, self.bounds.size.width, stepHei*24+topPadding))
        
        for i in 1...24 {
            let am = i < 13 ? "AM" : "PM"
            let clock = i < 13 ? i : i-12
            
            let y = CGFloat(CGFloat(i-1) * stepHei + topPadding)
            
            let descLabel = UILabel.init(frame: CGRectMake(0, y-10, labelWid, 20))
            
            descLabel.text = String("\(clock) \(am)")
            descLabel.textColor = GRAY_COLOR_3
            descLabel.textAlignment = NSTextAlignment.Right
            descLabel.font = Utilities.fontWithSize(13)
            descLabel.backgroundColor = UIColor.clearColor()
            timelineView.addSubview(descLabel)
            
            let lineView = UIView.init(frame: CGRectMake(labelWid + leftPadding, y, lineWid, 1))
            lineView.backgroundColor = GRAY_COLOR_6
            timelineView.addSubview(lineView)
        }
        
        containerScrollView.addSubview(timelineView)
    }
    
    func updateContainerSize() {
        containerScrollView.frame = self.bounds
    }
    
    func addShift(shiftObj: NSShift) {
        if (self.containerScrollView == nil) {
            self.drawLine()
        }
        self.containerScrollView.addSubview(self.createShiftView(shiftObj))
    }
    
    
    private func createShiftView(shiftObj: NSShift) -> UIView {
        let padding:CGFloat = 10
        let labelHei:CGFloat = 20
        
        let lineWid = CGFloat(self.bounds.size.width - labelWid - rightPadding)
        let width = CGFloat(lineWid - padding*2)
        let xPos = CGFloat(labelWid + padding)
        
        let startInterval = shiftObj.startAt.timeIntervalSince1970
        let endInterval = shiftObj.endAt.timeIntervalSince1970
        let steps = CGFloat((endInterval-startInterval) / (60*60))
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: shiftObj.startAt)
        
        let hour = CGFloat(components.hour)
        let minute = CGFloat(components.minute)
        let startStep = CGFloat(hour + minute/60)
        
        let height = steps * stepHei
        let yPos = topPadding + startStep * stepHei
        
        let shiftView = UIView.init(frame: CGRectMake(xPos, yPos, width, height))
        shiftView.backgroundColor = shiftObj.color
        
        let titleLabel = UILabel.init(frame: CGRectMake(padding, padding-5, lineWid - padding*2, labelHei))
        titleLabel.text = shiftObj.title
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = Utilities.boldFontWithSize(14)
        shiftView.addSubview(titleLabel)
        
        let posterLabel = UILabel.init(frame: CGRectMake(padding, padding - 5 + labelHei + 5, lineWid - padding*2, labelHei))
        if (steps < 1) {
            titleLabel.frame = CGRectMake(padding, padding-5, 100, labelHei)
            posterLabel.frame = CGRectMake(padding + 100, padding - 5, lineWid - padding*2, labelHei)
        }
        posterLabel.text = "(\(shiftObj.employeeName))"
        posterLabel.textColor = UIColor.whiteColor()
        posterLabel.font = Utilities.boldFontWithSize(11)
        shiftView.addSubview(posterLabel)
        
        shiftArray.addObject(shiftObj)
        shiftView.tag = shiftArray.count - 1
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: Selector("tapGestureHandler:"))
        tapGesture.delegate = self
        shiftView.addGestureRecognizer(tapGesture)
        

        
        
        return shiftView
    }
    
    func tapGestureHandler(recognizer: UITapGestureRecognizer) {
        let index = recognizer.view?.tag
        self.delegate?.shiftDidSelect(shiftArray[index!] as! NSShift)
    }
}
