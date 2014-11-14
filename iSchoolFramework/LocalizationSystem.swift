//
//  LocalizationSystem.swift
//  iSchool
//
//  Created by Starkadur Hrobjartsson on 13.11.2014.
//  Copyright (c) 2014 OrangeJam. All rights reserved.
//

import UIKit

private let _localizer = LocalizationSystem()

class LocalizationSystem {
    
    var bundle: NSBundle = NSBundle.mainBundle()
    
    
    class var sharedInstance: LocalizationSystem {
        return _localizer
    }
    
    func localizedStringForKey(key: String, comment: String) -> String {
        return bundle.localizedStringForKey(key, value: comment, table: nil)
    }
    
    func setLanguage(language: String) {
        if let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj") {
            bundle = NSBundle(path: path)!
        } else {
            self.resetLocalization()
        }
        NSUserDefaults.standardUserDefaults().setObject(language, forKey: "language")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func resetLocalization() {
        bundle = NSBundle.mainBundle()
    }
    
    func getLanguage() -> String {
        // If the app has a
        if let language = NSUserDefaults.standardUserDefaults().stringForKey("language") {
            return language
        }
        // Return the preferred language of the phone.
        let languages = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") as [String]
        let preferredLanguage = languages[0]
        return preferredLanguage
    }
}
