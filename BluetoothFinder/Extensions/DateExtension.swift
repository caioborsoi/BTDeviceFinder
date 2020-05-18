//
//  DateExtension.swift
//  BluetoothFinder
//
//  Created by Caio Borsoi on 5/17/20.
//  Copyright © 2020 Caio Borsoi. All rights reserved.
//

import Foundation

extension Date {
    func toString(dateFormat: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
