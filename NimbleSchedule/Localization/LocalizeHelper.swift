//
//  LocalizeHelper.swift
//  NimbleSchedule
//
//  Created by Yulian Simeonov on 1/17/16.
//
//

import UIKit

class LocalizeHelper {

    private var myBundle: NSBundle? = nil
    
    var lang: String {
        didSet {
            self.languageSetter()
        }
    }
    
    class var sharedInstance: LocalizeHelper {
        struct Static {
            static let instance: LocalizeHelper = LocalizeHelper()
        }
        return Static.instance
    }
    
    init() {
        myBundle = NSBundle .mainBundle()
        lang = "en"
    }
    
    func languageSetter() {
        let langCode = self.lang == "en" ? ELangCode.English : ELangCode.France
        SharedDataManager.sharedInstance.langCode = langCode
        
        // path to this languages bundle
        let path = NSBundle.mainBundle().pathForResource(self.lang, ofType: "lproj")
        if path == nil {
            // there is no bundle for that language
            // use main bundle instead
            myBundle = NSBundle.mainBundle()
        } else {
            // use this bundle as my bundle from now on:
            myBundle = NSBundle.init(path: path!)
            
            // to be absolutely shure (this is probably unnecessary):
            if myBundle == nil {
                myBundle = NSBundle.mainBundle()
            }
        }
    }
    
    // Return localized image
    func localizedImageForKey(key: String) -> UIImage {
        
        var imageName = key
        if self.lang != "en" {
            imageName = "\(key)-\(self.lang)"
        }
        var image = UIImage.init(named: imageName)
        if image == nil {
            image = UIImage.init(named: key)
        }
        return image!
    }
    
    // Return localized string from Key String
    func localizedStringForKey(key: String) -> String {
        
        return (myBundle?.localizedStringForKey(key, value: key, table: nil))!
    }
    
    // Return localized array from Key Array
    func localizedArrayForKeyArray(keysArray: NSArray) -> NSArray {
        
        let array = NSMutableArray()
        for key in keysArray {
            array.addObject((myBundle?.localizedStringForKey(key as! String, value: key as? String, table: nil))!)
        }
        return array as NSArray
    }
}
