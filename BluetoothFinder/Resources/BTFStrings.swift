//
//  BTFStrings.swift
//  BluetoothFinder
//
//  Created by Caio Borsoi on 5/17/20.
//  Copyright © 2020 Caio Borsoi. All rights reserved.
//

enum BTFStrings: String {
    var localized: String {
        return self.rawValue.localized
    }
    
    //MARK: - DeviceDetail
    
    case kReusableCellIdentifier
    case kReusableCellKeyPath
    case kTitlePairDisconnected
    case kTitlePairConnect
    case kFilterDevice
    case kAlertTitleDetail
    case kAlertMessageDetail
    case kOk
    case kCancel
    
    //MARK: - DeviceList
    
    case kCellIdentifier
    case kSegueDetail
    case kSearch
    case kSearching
    case kAttention
    case kBTTurnedOff
    case kBTNotAuthorized
    
    //MARK: - DataStore
    
    case kEntityName
    case kErrorTitle
    
    //MARK: - BTDeviceModel
    
    case kPeripheralNoName
    
    //MARK: - CBCentralManagerDelegate - States
    
    case kPoweredOn
    case kPoweredOff
    case kResetting
    case kUnauthorized
    case KUnsupported
    case kUnknown
}
