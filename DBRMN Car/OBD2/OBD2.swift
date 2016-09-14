//
//  OBD2.swift
//  DBRMN Car
//
//  Copyright © 2016 Doberman AB. All rights reserved.
//

//import Cocoa
import Foundation

enum OBD2SensorType : String {
    case RPM = "0C"
    case Speed = "0D"
    case MassAirFlow = "10"
    case FuelTankLevel = "2F"
    case EngineFuelRate = "5E"
    
    static let allValues = [
        OBD2SensorType.RPM,
        OBD2SensorType.Speed,
        OBD2SensorType.MassAirFlow,
        OBD2SensorType.FuelTankLevel,
        OBD2SensorType.EngineFuelRate
    ]
}
//let kOBD2SensorEngineCoolantTemperature = "05"
//let kOBD2SensorRPM = "0C"
//let kOBD2SensorVehicleSpeed = "0D"
//let kOBD2SensorAirIntakeTemperature = "0F"
//let kOBD2SensorMassAirFlow = "10"
//let kOBD2SensorVehicleFuelLevel = "2F"
//let kOBD2SensorControlModuleVoltage = "42"
//let kOBD2SensorAmbientAirTemperature = "46"
//let kOBD2SensorFuelFlow = "kOBD2PIDFuelFlow"

protocol ODB2Delegate {
    func didReceiveSensorData(sensor: OBD2SensorType, value: Double)
}

class OBD2: NSObject, FAOBD2CommunicatorDelegate {
    
    var delegate : ODB2Delegate?
    
    init(sensorTypes : Array<OBD2SensorType> = OBD2SensorType.allValues) {
        super.init()
        self.setupOBD2(sensorTypes)
    }
    
    private func setupOBD2(sensorTypes : Array<OBD2SensorType>) {
        let communicator: FAOBD2Communicator = FAOBD2Communicator.sharedInstance() as! FAOBD2Communicator
        communicator.delegate = self
        communicator.startStreaming(sensorTypes.map({ v in v.rawValue }))
    }
    
    // MARK. - FAOBD2CommunicatorDelegate
    func FAOBD2CommunicatorReceivedDataForSensor(sensor: String!, withBytes bytes: [AnyObject]!) {
        print("FAOBD2Communicator - receivedDataForSensor - sensor: \(sensor)")
        
        let bytesArray = bytes as! Array<NSNumber>
//
        switch sensor {
        case OBD2SensorType.RPM.rawValue:
            let value = Double(256 * bytesArray[0].intValue + bytesArray[1].intValue) / 4 // rpm
            self.delegate?.didReceiveSensorData(.RPM, value: value)
        case OBD2SensorType.Speed.rawValue:
            let value = Double(bytesArray[0]) // km/h
            self.delegate?.didReceiveSensorData(.Speed, value: value)
        case OBD2SensorType.MassAirFlow.rawValue:
            let value = Double(256 * bytesArray[0].intValue + bytesArray[1].intValue) / 100 // g/s
            self.delegate?.didReceiveSensorData(.MassAirFlow, value: value)
        case OBD2SensorType.FuelTankLevel.rawValue:
            let value = Double(bytesArray[0].intValue * 100) / 255 // percent
            self.delegate?.didReceiveSensorData(.FuelTankLevel, value: value)
        case OBD2SensorType.EngineFuelRate.rawValue:
            let value = Double(256*bytesArray[0].intValue + bytesArray[1].intValue) / 20 // l/h
            self.delegate?.didReceiveSensorData(.EngineFuelRate, value: value)
        default:
            print("UNHANDLED sensorID! (\(sensor))")
        }
    }
    

}
