//
//  ViewController.swift
//  ANSCApp-OSX
//
//  Created by 清 貴幸 on 2015/11/03.
//  Copyright © 2015年 DayBySay. All rights reserved.
//

import Cocoa
import CoreBluetooth

class ViewController: NSViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var notificationSourceCharacteristic: CBCharacteristic!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("central state: \(central.state.rawValue)")
        switch central.state {
        case .PoweredOn:
            self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
        default:
            break
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        print("peripheral: \(peripheral)")
//        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] where localName as? String == "Takayuki Device" {
            self.centralManager.connectPeripheral(peripheral, options: nil)
            self.peripheral = peripheral
            self.peripheral.delegate = self
            self.centralManager.stopScan()
//        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("connected!")
        peripheral.discoverServices([CBUUID(string: "7905F431-B5CE-4E99-A40F-4B1E122D00D0")])
//        peripheral.discoverServices(nil)
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("failed...")
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        if (error != nil) {
            print("error: \(error)")
            return
        }
        
        if !(peripheral.services?.count > 0) {
            print("no services")
            return
        }
        
        let services = peripheral.services!
        print("Found \(services.count) services! :\(services)")
        for service in services {
            print("service uuid \(service.UUID)")
            peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        let notificationServiceUUID = CBUUID(string: "9FBF120D-6301-42D9-8C58-25E699A21DBD")
        for characteristic in service.characteristics! {
            print("characteristic uuid \(characteristic.UUID)")
            if characteristic.UUID == notificationServiceUUID {
                self.notificationSourceCharacteristic = characteristic
                self.peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("characteristic value \(characteristic.value)")
    }
}

