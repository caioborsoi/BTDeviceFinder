//
//  Manager.swift
//  BluetoothFinder
//
//  Created by Caio Borsoi on 5/10/20.
//  Copyright © 2020 Caio Borsoi. All rights reserved.
//

import CoreBluetooth

class Manager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    
   private var manager: CBCentralManager!

   required override init() {
      super.init()
      //manager = CBCentralManager.init(delegate: self, queue: nil)
        manager = CBCentralManager(delegate: self, queue: nil);

//        findDivices()
   }
    
    func findDivices() {
        manager.scanForPeripherals(withServices: nil, options: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.stopScanForBLEDevices()
        }
    }
    
    func stopScanForBLEDevices() {
        manager.stopScan()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
}
