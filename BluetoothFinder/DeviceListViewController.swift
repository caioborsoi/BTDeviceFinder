//
//  ViewController.swift
//  BluetoothFinder
//
//  Created by Caio Borsoi on 5/9/20.
//  Copyright © 2020 Caio Borsoi. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceListViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    var peripherals:[CBPeripheral] = []
    var manager: CBCentralManager?
    var devices:[BTDeviceModel] = []
    var selectedDevice: BTDeviceModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        manager = CBCentralManager(delegate: self, queue: nil)
    }

    func findDevices() {
        searchBtn.title = "Buscando"
        manager?.scanForPeripherals(withServices: nil, options: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.searchBtn.title = "Buscar"
            self.stopSearch()
        }
    }
    
    func stopSearch() {
        manager?.stopScan()
    }
    
    @IBAction func searchButtonPressed(_ sender: AnyObject) {
        if devices.count > 0 {
            peripherals.removeAll()
            devices.removeAll()
            tableView.reloadData()
        }
        findDevices()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail"{
            let deviceDetailVC = segue.destination as! DeviceDetailViewController
            manager?.delegate = deviceDetailVC
            deviceDetailVC.device = selectedDevice
            deviceDetailVC.deviceID = "\(selectedDevice!.peri.identifier)"
            deviceDetailVC.manager = manager
            deviceDetailVC.previousVC = self
        }
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
        let device = devices[indexPath.row]
        selectedDevice = device
        
        performSegue(withIdentifier: "segueDetail", sender: nil)
    }
    
    // MARK: - CBCentralManagerDelegate
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

