//
//  NSPosition.swift
//  NimbleSchedule
//
//  Created by Yosemite on 12/14/15.
//  Copyright © 2015 YulianMobile. All rights reserved.
//

import UIKit

class NSPosition {
    var ID: String
    var name: String
    var colorHex: String
    var color: UIColor
    
    class func initWithDictionary(positionDict: NSDictionary) -> NSPosition? {
        let position = NSPosition()
        if (positionDict["id"] == nil) {
            return nil
        }
        position!.ID = positionDict["id"] as! String
        position!.name = Utilities.getValidString(positionDict["name"] as? String, defaultString: "None")
        position!.colorHex = Utilities.getValidString(positionDict["color"] as? String, defaultString: "FFFFFF")
        position!.color = UIColor(rgba: "#\(position!.colorHex)")
        
        return position
    }
    
    init?() {
        self.ID = "123"
        self.name = ""
        self.colorHex = "FFFFFF"
        self.color = UIColor.init()
        
        if (self.ID.isEmpty) {
            return nil
        }
    }
}
