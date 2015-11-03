//
//  ViewController.swift
//  ANSCApp-iOS
//
//  Created by 清 貴幸 on 2015/11/03.
//  Copyright © 2015年 DayBySay. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        if (error != nil) {
            print("Failed... error: \(error)")
            return
        }
        
        print("Succeeded!")
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        print("state: \(peripheral.state.rawValue)")
        switch peripheral.state {
        case .PoweredOn:
            let advertisementData = [CBAdvertisementDataLocalNameKey: "Takayuki Device"]
            self.peripheralManager.startAdvertising(advertisementData)
        default:
            return
        }
    }
}

