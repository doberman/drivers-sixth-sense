//
//  StartViewController.swift
//  DBRMN Car
//
//  Copyright © 2016 Doberman AB. All rights reserved.
//

import UIKit
import SocketIOClientSwift
import SwiftyTimer
import SpeechKit
import AVFoundation

class StartViewController: UIViewController, SKTransactionDelegate, ODB2Delegate {
    
    var socket: SocketIOClient!
    var obd2: OBD2!
    var session: SKSession!
    var speechSynthesizer: AVSpeechSynthesizer!
    var isAboveSpeedLimit: Bool = false
    let speedLimit: Double = 30.0
    
    @IBOutlet weak var RPMValueLabel: UILabel!
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.obd2 = OBD2(sensorTypes: [.Speed, .FuelTankLevel, .RPM])
        self.obd2.delegate = self
        
        self.setupSpeechKit()
        
        self.speechSynthesizer = AVSpeechSynthesizer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupSocketIO() {
        self.socket = SocketIOClient(socketURL: NSURL(string: "http://localhost:9000")!, options: [.Log(false), .ForcePolling(true)])
        
        self.socket.on("connect") { (data, ack) in
            print("socket connected")
            
            NSTimer.every(1.0, {
                self.socket.emit("msg-from-client", "hahaha")
            })
        }
        
        self.socket.on("disconnect") { (data, ack) in
            print("socket disconnected")
        }
        
        self.socket.on("msg-from-server") { (data, ack) in
            print("msg-from-server: \(data)")
        }
        
        self.socket.connect()
    }
    
    private func setupSpeechKit() {
        print(kSpeechKitAppToken)
        print(kSpeechKitServerHostname)
        let SKSServerUrl = "nmsps://\(kSpeechKitAppID)@\(kSpeechKitServerHostname):\(kSpeechKitServerPort)"
        self.session = SKSession(URL: NSURL(string: SKSServerUrl), appToken: kSpeechKitAppToken)
        self.session.recognizeWithType(SKTransactionSpeechTypeDictation, detection: .Short, language: "eng-USA", delegate: self)
    }
    
    private func say(message: String, rate: Float = 1.0, stopCurrentUtterance: Bool = false) {
        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: message)
        if self.speechSynthesizer.speaking && stopCurrentUtterance {
            self.speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
        }
        self.speechSynthesizer.speakUtterance(utterance)
    }
    
    //MARK: - OBD2Delegate
    func didReceiveSensorData(sensor: OBD2SensorType, value: Double) {
        print("StartViewController.didRecieveSensorData: \(sensor): \(value)")
        
        switch sensor {
            case OBD2SensorType.RPM:
                break
            
            case OBD2SensorType.Speed:
                if value > self.speedLimit && !self.isAboveSpeedLimit {
                    self.isAboveSpeedLimit = true
                    
                    WatchSessionManager.sharedInstance.sendAlert()
                } else if value < self.speedLimit && self.isAboveSpeedLimit {
                    self.isAboveSpeedLimit = false
                }
                break
        
            case .FuelTankLevel:
                print("FUEL: \(value)")
                self.say("Fuel level currently at \(Int(value)) %")
                if value < 20 {
                    self.say("WARNING. Fuel low.")
                }
                break
            
            default:
                break
        }
    }
    
    // MARK: - SKTransactionDelegate
    func transactionDidBeginRecording(transaction: SKTransaction!) {
        print("Transaction did begin recording")
    }
    
    func transactionDidFinishRecording(transaction: SKTransaction!) {
        print("Transaction did finish recording")
    }
    
    func transaction(transaction: SKTransaction!, didReceiveRecognition recognition: SKRecognition!) {
        let topRecognitionText = recognition.text;
        print(topRecognitionText)
        if (topRecognitionText == "Start engine") {
            let textToSpeak = "Starting engine";
            
            let options = [SKOptionsAutoPlayTTSKey: false];
            _ = self.session.speakString(textToSpeak, withVoice: "Samantha", options:options, delegate: self)
        } else {
            let textToSpeak = "I dont understand";
            
            let options = [SKOptionsAutoPlayTTSKey: false];
            _ = self.session.speakString(textToSpeak, withVoice: "Samantha", options:options, delegate: self)
        }
    }
    
    func transaction(transaction: SKTransaction!, didReceiveAudio audio: SKAudio!) {
        self.session.audioPlayer.playAudio(audio)
    }
    
    func transaction(transaction: SKTransaction!, didReceiveServiceResponse response: [NSObject : AnyObject]!) {
    }
    func transaction(transaction: SKTransaction!, didFinishWithSuggestion suggestion: String!) {
    }
    func transaction(transaction: SKTransaction!, didFailWithError error: NSError!, suggestion: String!) {
    }
}
