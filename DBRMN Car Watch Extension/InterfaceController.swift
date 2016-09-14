//
//  InterfaceController.swift
//  DBRMN Car Watch Extension
//
//  Copyright © 2016 Doberman AB. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class HapticTypesTableRowController: NSObject, WCSessionDelegate {
    @IBOutlet var button: WKInterfaceButton!
    
    var hapticType = WKHapticType.Click
    
    @IBAction func buttonPressed() {
        WKInterfaceDevice.currentDevice().playHaptic(hapticType)
    }
}

class InterfaceController: WKInterfaceController {
    @IBOutlet var hapticTypesTable: WKInterfaceTable!
    
    let hapticTypeAllValues: [(String, WKHapticType)] = [
        ("Notification",    .Notification),
        ("DirectionUp",     .DirectionUp),
        ("DirectionDown",   .DirectionDown),
        ("Success",         .Success),
        ("Failure",         .Failure),
        ("Retry",           .Retry),
        ("Start",           .Start),
        ("Stop",            .Stop),
        ("Click",           .Click)
    ]
    
    var session: WCSession?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.setupWatchConnectivityDelegate()
        self.setupHapticTypesTable()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func setupWatchConnectivityDelegate() {
        if (WCSession.isSupported()) {
            self.session = WCSession.defaultSession()
            self.session!.delegate = self
            self.session!.activateSession()
        }
    }
    
    private func setupHapticTypesTable() {
        self.hapticTypesTable.setNumberOfRows(hapticTypeAllValues.count, withRowType: "HapticTypesTableRowControllerIdentifier")
        
        for (index, hapticInfo) in hapticTypeAllValues.enumerate() {
            let (hapticName, hapticType) = hapticInfo
            let row = self.hapticTypesTable.rowControllerAtIndex(index) as! HapticTypesTableRowController
            
            row.button.setTitle(hapticName)
            row.hapticType = hapticType
        }
    }
    
    private func onNewSpeed(newSpeed: AnyObject) {
        print("InterfaceController.onNewSpeed")
        
        WKInterfaceDevice.currentDevice().playHaptic(WKHapticType.Failure)
        
//        if let newSpeed = Double(newSpeed as! String) {
//            let iteratableNewSpeed = Int(floor(newSpeed / 10)) - 1
//            
//            for index in 0...iteratableNewSpeed {
//                let delay = Double(index) * 0.2
//                    
//                NSTimer.after(delay) {
//                    WKInterfaceDevice.currentDevice().playHaptic(WKHapticType.Click)
//                }
//            }
//        }
    }
}


// MARK: - WCSessionDelegate
extension InterfaceController: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String: AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("InterfaceController.session:didRecieveMessage:")
        print(message)
        
        for message in message {
            let eventName = message.0
            let eventValue = message.1
            
            switch eventName {
                case "event:newSpeed":
                    self.onNewSpeed(eventValue)
                    break
                default: break
            }
        }
    }
}
