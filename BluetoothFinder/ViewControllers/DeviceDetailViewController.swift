//
//  DeviceDetailViewController.swift
//  BluetoothFinder
//
//  Created by Caio Borsoi on 5/16/20.
//  Copyright © 2020 Caio Borsoi. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreData

class DeviceDetailViewController: UIViewController, CBCentralManagerDelegate {
    
    @IBOutlet weak var signalLbl: UILabel!
    @IBOutlet weak var pairBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyLbl: UILabel!
    
    var device: BTDeviceModel?
    var manager: CBCentralManager?
    var savedDevices: [DeviceModel] = []
    var deviceID = String()
    var previousVC: DeviceListViewController? = nil
    
    let kSavedDevicesZero = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if let dev = device {
            setUI(device: dev)
        }
        setupTableView()
        setupHistory()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        manager?.delegate = previousVC
    }
    
    private func setUI(device: BTDeviceModel) {
        title = device.name
        signalLbl.text = "intensidade do sinal: \(device.rssi)db"
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: BTFStrings.kCellIdentifier.localized)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setupHistory() {
        if let filterDevice = DataStore.shared.read(predicate: NSPredicate(format: BTFStrings.kFilterDevice.localized, deviceID)) {
            savedDevices = filterDevice
        }
        let shouldHide = savedDevices.count == kSavedDevicesZero
        historyLbl.isHidden = shouldHide
        tableView.isHidden = shouldHide
    }
        
    @IBAction func connectBtnPressed(_ sender: Any) {
        guard let dev = device else { return }
        if dev.peri.state == CBPeripheralState.connected {
            manager?.cancelPeripheralConnection(dev.peri)
        } else {
            manager?.connect(dev.peri, options: nil)
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        pairBtn.setTitle(BTFStrings.kTitlePairDisconnected.localized, for: .normal)
        DataStore.shared.save(id: deviceID, date: Date())
        savedDevices = DataStore.shared.read(predicate: NSPredicate(format: BTFStrings.kFilterDevice.localized, deviceID))!
        historyLbl.isHidden = false
        tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        pairBtn.setTitle(BTFStrings.kTitlePairConnect.localized, for: .normal)
        historyLbl.isHidden = false
        tableView.isHidden = false
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        popupAlert(title: BTFStrings.kAlertTitleDetail.localized, message: BTFStrings.kAlertMessageDetail.localized, actionTitles: [BTFStrings.kOk.localized], actions: [{connectAction in
            guard let dev = self.device else { return }
            self.manager?.connect(dev.peri, options: nil)
            },{cancelAction in
                self.dismiss(animated: true, completion: nil)
            }])
        print(error!)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
}

// MARK: - UITableViewDataSource

extension DeviceDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let deviceHistory = savedDevices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: BTFStrings.kCellIdentifier.localized, for: indexPath)
        cell.textLabel?.text = (deviceHistory.value(forKeyPath: BTFStrings.kReusableCellKeyPath.localized) as? Date)?.toString()
        return cell
    }
}
