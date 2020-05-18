//
//  StringExtension.swift
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
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: String(), comment: String())
    }
}
