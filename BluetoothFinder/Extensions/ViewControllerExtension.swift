//
//  ViewControllerExtension.swift
//  BluetoothFinder
//
//  Created by Caio Borsoi on 5/17/20.
//  Copyright © 2020 Caio Borsoi. All rights reserved.
//

import UIKit

extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
