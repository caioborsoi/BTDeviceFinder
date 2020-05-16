//
//  ViewController.swift
//  BluetoothFinder
//
//  Created by Caio Borsoi on 5/9/20.
//  Copyright © 2020 Caio Borsoi. All rights reserved.
//

import UIKit
import CoreBluetooth


struct bluetoothDevice {
    
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

class DeviceListViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var peripherals:[CBPeripheral] = []
    var manager: CBCentralManager?
    var devices:[bluetoothDevice] = []
    var selectedDevice: bluetoothDevice?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CBCentralManager(delegate: self, queue: nil);
    }
    
    func findDivices() {
        manager?.scanForPeripherals(withServices: nil, options: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.stopScanForBLEDevices()
        }
    }
    
    func stopScanForBLEDevices() {
        manager?.stopScan()
    }
    
    @IBAction func sendButtonPressed(_ sender: AnyObject) {
        devices.removeAll()
        tableView.reloadData()
        findDivices()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothDeviceCell", for: indexPath)
        
        let device = devices[indexPath.row]
        
        cell.textLabel?.text = device.name
        cell.textLabel?.text?.append("\(device.rssi)")
        
        return cell
    }
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //let peripheral = peripherals[indexPath.row]
            let device = devices[indexPath.row]
            
            selectedDevice = device
            

            //manager?.connect(peripheral, options: nil)
            //performSegue
            performSegue(withIdentifier: "segueDetail", sender: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail"{
            let deviceDetailVC = segue.destination as! DeviceDetailViewController
            manager?.delegate = deviceDetailVC
            deviceDetailVC.device = selectedDevice
            deviceDetailVC.deviceID = "\(selectedDevice!.peri.identifier)"
            deviceDetailVC.manager = manager
        }
    }
    
    // MARK: - CBCentralManagerDelegate Methods
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(!peripherals.contains(peripheral)) {
            peripherals.append(peripheral)
            devices.append(.init(peri: peripheral, rssi: RSSI))
            devices.sort() { $0.rssi.intValue > $1.rssi.intValue }
        }
        self.tableView.reloadData()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
}

