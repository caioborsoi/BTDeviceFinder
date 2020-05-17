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

class DeviceDetailViewController: UIViewController, CBCentralManagerDelegate{
    
    @IBOutlet weak var signalLbl: UILabel!
    @IBOutlet weak var pairBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyLbl: UILabel!
    
    var device: BTDeviceModel!
    var manager: CBCentralManager?
    var savedDevices: [DeviceModel] = []
    var deviceID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = device.name
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "historyCell")
        tableView.tableFooterView = UIView(frame: .zero)
        signalLbl.text = "intensidade do sinal: \(device.rssi)db"
        setupHistory()
    }
    
    func setupHistory() {
        if let filterDevice = DataStore.shared.read(predicate: NSPredicate(format: "deviceID == %@", deviceID)){
            
            savedDevices = filterDevice
        }
        
        if savedDevices.count == 0 {
            historyLbl.isHidden = true
            tableView.isHidden = true
        }else {
            historyLbl.isHidden = false
            tableView.isHidden = false
        }
    }
    
    @IBAction func connectBtnPressed(_ sender: Any) {
        if device.peri.state == CBPeripheralState.connected{
            manager?.cancelPeripheralConnection(device.peri)
        } else {
            manager?.connect(device.peri, options: nil)
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        pairBtn.setTitle("Desparear", for: .normal)
        
        DataStore.shared.save(id: deviceID, date: Date())
        savedDevices = DataStore.shared.read(predicate: NSPredicate(format: "deviceID == %@", deviceID))!
        self.tableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected to " +  device.peri.name!)
        pairBtn.setTitle("Parear", for: .normal)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let alert = UIAlertController(title: "Erro ao tentar connectar", message: "tentar conectar novamente?", preferredStyle: .alert)
        
        let connectAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            self.manager?.connect(self.device.peri, options: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alert.addAction(connectAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = (deviceHistory.value(forKeyPath: "date") as? Date)?.toString()
        
        return cell
    }
}
