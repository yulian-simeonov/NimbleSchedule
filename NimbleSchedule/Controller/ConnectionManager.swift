//
//  ConnectionManager.swift
//  FAB
//
//  Created by iDev on 4/9/15.
//  Copyright (c) 2015 es. All rights reserved.
//

import Foundation

class ConnectionManager: AFHTTPRequestOperationManager {
    
    class var sharedInstance: ConnectionManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ConnectionManager? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = ConnectionManager()
//            Static.instance?.securityPolicy.allowInvalidCertificates = true
            Static.instance?.responseSerializer = AFHTTPResponseSerializer()
        }
        
        return Static.instance!
    }
}