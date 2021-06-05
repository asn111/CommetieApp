//
//  AppFunctions.swift
//  Job Manager
//
//  Created by Ahsan Iqbal on Friday14/08/2020.
//  Copyright © 2020 SelfIt. All rights reserved.
//

import Foundation


//MARK:- Globel Variables

var dateNow : Date!


//MARK: Strings

let isFirstLogin = "isFirstLogin"


class Logs {
    
    open class func value(fileName:String = #file,
                          functionName: String = #function,
                          isLogTrue : Bool = false,
                          message: String) {
        let file = URL(fileURLWithPath: fileName).lastPathComponent
        if isLogTrue{
            NSLog("\n 🍏 👉🏻 \(file) - \(functionName) , Message: \(message)\n", 0)
        }
        #if DEBUG
        print("\n 🍏 👉🏻 \(file) - \(functionName) , Message: \(message)\n")
        #endif
    }
}


class AppFunctions {
    
    static let preferences = UserDefaults.standard
    
    //MARK:- PREFS
    
    open class func setIsFirstLogin( val: Bool){
        preferences.set(val, forKey: isFirstLogin)
        preferences.synchronize()
    }
    
    open class func getIsFirstLogin(forKey: String) -> Bool{
        var val = false
        if preferences.object(forKey: forKey) == nil {
            Logs.value(message: "NIL getIsFirstLogin")
        } else {
            val = preferences.bool(forKey: forKey)
        }
        return val
    }
    

    
    //MARK: Remove all data
    
    open class func resetDefaults2() {
        if let bundleID = Bundle.main.bundleIdentifier {
            AppFunctions.preferences.removePersistentDomain(forName: bundleID)
        }
    }
    
    
   
    
   open class func calculateElapsedTime(startingPoint : Date, s:String, functionName: String) {
        //startingPointA = startingPoint
        
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m:ss.SSSS"
        print(df.string(from: dateNow))
        let startingPointA = dateNow
        func stringFromTimeInterval(interval: TimeInterval) -> NSString {
            let ti = NSInteger(interval)
            let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
            let seconds = ti % 60
            let minutes = (ti / 60) % 60
            let hours = (ti / 3600)
            return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        }
        
        Logs.value(message:  "TIME ELAPSED in \(functionName) \(s):  \(stringFromTimeInterval(interval: startingPointA!.timeIntervalSinceNow * -1))")
    }
    
   
}
