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
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
    

    @IBOutlet weak var signalLbl: UILabel!
    @IBOutlet weak var pairBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var device: bluetoothDevice!
    var manager: CBCentralManager?
    var savedDevices: [NSManagedObject] = []


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = device.name
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "historyCell")
        signalLbl.text = "intensidade do sinal: \(device.rssi)db"
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      

      let managedContext = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DeviceHistory")

      do {
        savedDevices = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
    func save(date: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DeviceHistory", in: managedContext)!
        let connectedDate = NSManagedObject(entity: entity, insertInto: managedContext)
        connectedDate.setValue(date, forKeyPath: "date")


        do {
          try managedContext.save()
          savedDevices.append(connectedDate)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
      }
    
    
    @IBAction func connectBtnPressed(_ sender: Any) {
        if device.peri.state == CBPeripheralState.connected{
            manager?.cancelPeripheralConnection(device.peri)
        } else {
            manager?.connect(device.peri, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to " +  device.peri.name!)
        pairBtn.setTitle("Desparear", for: .normal)
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from: date as Date)

        self.save(date: dateString)
        self.tableView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected to " +  device.peri.name!)
        pairBtn.setTitle("Parear", for: .normal)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
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
    cell.textLabel?.text = deviceHistory.value(forKeyPath: "date") as? String

    return cell
  }
}

