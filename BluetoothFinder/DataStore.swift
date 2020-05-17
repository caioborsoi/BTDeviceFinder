//
//  DataStore.swift
//  BluetoothFinder
//
//  Created by Caio Borsoi on 5/16/20.
//  Copyright © 2020 Caio Borsoi. All rights reserved.
//

import UIKit
import CoreData

class DataStore {
    static var shared = DataStore()
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(id:String, date: Date) {
        let entity = NSEntityDescription.entity(forEntityName: "DeviceModel", in: managedContext)!
        let dm = DeviceModel(entity: entity, insertInto: managedContext)
        dm.date = date
        dm.deviceID = id
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func read(predicate: NSPredicate?) -> [DeviceModel]?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DeviceModel")
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        do {
            let savedModel: [AnyObject] = try managedContext.fetch(fetchRequest)
            var finalModel: [DeviceModel] = []
            for temp in savedModel {
                if let p = temp as? DeviceModel {
                    finalModel.append(p)
                }
            }
            return finalModel.sorted(by: { $0.date! > $1.date! })
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
