//
//  WatchSessionManager.swift
//  DBRMN Car
//
//  Copyright © 2016 Doberman AB. All rights reserved.
//

import WatchConnectivity

class WatchSessionManager: NSObject {
    
    static let sharedInstance = WatchSessionManager()

    var session: WCSession?
    
    override init() {
        print("WatchSessionManager.init")
        
        super.init()
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session!.delegate = self
            session!.activateSession()
        }
    }
    
    func sendAlert() {
        let message = ["event:newSpeed": "1"]
        
        self.sendMessage(message)
    }
    
    func sendMessage(message: [String: AnyObject]) {
        if let session = self.session {
            session.sendMessage(message, replyHandler: self.replyHandler, errorHandler: self.errorHandler)
        }
    }
    
    private func replyHandler(message: [String : AnyObject]) {
        print("WatchSessionManager.replyHandler:")
        print(message)
    }
    
    private func errorHandler(error: NSError) {
        print("WatchSessionManager.errorHandler:")
        print(error)
    }
}


// MARK: - WCSessionDelegate
extension WatchSessionManager: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String: AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("WatchSessionManager.session:didRecieveMessage:")
        print(message)
    }
}
