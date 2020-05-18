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
    
    let kNumberOfSections = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        manager = CBCentralManager(delegate: self, queue: nil)
    }

    private func findDevices() {
        searchBtn.title = BTFStrings.kSearching.localized
        manager?.scanForPeripherals(withServices: nil, options: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.searchBtn.title = BTFStrings.kSearch.localized
            self.stopSearch()
        }
    }
    
    private func stopSearch() {
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
        if segue.identifier == BTFStrings.kSegueDetail.localized {
            guard let device = selectedDevice else { return }
            let deviceDetailVC = segue.destination as! DeviceDetailViewController
            manager?.delegate = deviceDetailVC
            deviceDetailVC.device = device
            deviceDetailVC.deviceID = "\(device.peri.identifier)"
            deviceDetailVC.manager = manager
            deviceDetailVC.previousVC = self
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return kNumberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BTFStrings.kReusableCellIdentifier.localized, for: indexPath)
        let device = devices[indexPath.row]
        cell.textLabel?.text = device.name
        cell.textLabel?.text?.append("\(device.rssi)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = devices[indexPath.row]
        selectedDevice = device
        performSegue(withIdentifier: BTFStrings.kSegueDetail.localized, sender: nil)
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
        switch central.state {
        case .poweredOn:
            print(BTFStrings.kPoweredOn.localized)
        case .poweredOff:
            print(BTFStrings.kPoweredOff.localized)
            popupAlert(title: BTFStrings.kAttention.localized, message: BTFStrings.kBTTurnedOff.localized, actionTitles: [BTFStrings.kOk.localized], actions: [{okAction in
                self.dismiss(animated: true, completion: nil)
                }])
        case .resetting:
            print(BTFStrings.kResetting.localized)
        case .unauthorized:
            print(BTFStrings.kUnauthorized.localized)
            popupAlert(title: BTFStrings.kAttention.localized, message: BTFStrings.kBTNotAuthorized.localized, actionTitles: [BTFStrings.kOk.localized], actions: [{okAction in
                self.dismiss(animated: true, completion: nil)
                }])
        case .unsupported:
            print(BTFStrings.KUnsupported.localized)
        case .unknown:
            print(BTFStrings.kUnknown.localized)
        default:
            print(central.state)
            break;
        }
    }
}
