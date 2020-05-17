//
//  BTDeviceModel.swift
//  BluetoothFinder
//
//  Created by Caio Borsoi on 5/17/20.
//  Copyright © 2020 Caio Borsoi. All rights reserved.
//

import UIKit
import CoreBluetooth


struct BTDeviceModel {
    
    var peri: CBPeripheral
    var rssi: NSNumber
    var name: String {
        self.peri.name ?? "Dispositivo Sem Nome"
    }
    
    init(peri: CBPeripheral, rssi: NSNumber) {
        
        self.peri = peri
        self.rssi = rssi
    }
}
