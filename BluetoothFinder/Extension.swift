//
//  Extension.swift
//  BluetoothFinder
//
//  Created by Caio Borsoi on 5/17/20.
//  Copyright © 2020 Caio Borsoi. All rights reserved.
//

import UIKit

extension String {
    func toDate(dateFormat: String = "dd/MM/yyyy HH:mm") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: self) else{return Date()}
        return date
    }
}

extension Date {
    func toString(dateFormat: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
