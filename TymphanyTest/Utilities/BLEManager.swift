//
//  BLEManager.swift
//  TymphanyTest
//
//  Created by 傅意芸 on 2022/7/21.
//

import UIKit
import CoreBluetooth

enum DeviceStatus: Int {
    case notConnected, connecting, connected
    
    init(cbPeripheralState: CBPeripheralState) {
        switch cbPeripheralState {
        case .connecting:
            self = .connecting
        case .connected:
            self = .connected
        default:
            self = .notConnected
        }
    }
}

struct BLEManagerDeviceModel {
    var name: String
    var identifier: String
    var hexValue: String
    var status: DeviceStatus
    var peripheral: CBPeripheral

    init(cbPeripheral: CBPeripheral, value: String = "") {
        self.peripheral = cbPeripheral
        self.name = cbPeripheral.name ?? ""
        self.identifier = cbPeripheral.identifier.uuidString
        self.hexValue = value
        self.status = DeviceStatus(cbPeripheralState: cbPeripheral.state)
    }
}

protocol BLEManagerDelegate {
    func didDiscover(model: BLEManagerDeviceModel)
}

class BLEManager: NSObject {
    
    static let shared = BLEManager()
    
    var delegate: BLEManagerDelegate?
    var currentPeripheral: CBPeripheral?
    var isScanning: Bool {
        return manager?.isScanning ?? false
    }
    
    private var manager: CBCentralManager?
    private var dictPeripheral: [String:CBPeripheral] = [:]
    
    private let uartService = "1fee6acf-a826-4e37- 9635-4d8a01642c5d"
    private let uartCharacteristic = "7691b78a-9015-4367- 9b95-fc631c412cc6"
    
    func scan() {
        if manager == nil {
            manager = CBCentralManager(delegate: self, queue: nil)
        } else {
            manager?.scanForPeripherals(withServices: [])
        }
    }
    
    func stopScan() {
        manager?.stopScan()
    }
    
    func connectTo(model: BLEManagerDeviceModel) {
        let connectToPeripheral = model.peripheral
        if connectToPeripheral.state == .connecting || connectToPeripheral.state == .connected {
            print("already connecting: \(connectToPeripheral.name ?? "")")
            disconnect()
            delegate?.didDiscover(model: BLEManagerDeviceModel(cbPeripheral: connectToPeripheral))
            return
        }
        
        if let currentPeripheral = self.currentPeripheral,
           currentPeripheral.state == .connected || currentPeripheral.state == .connecting {
            manager?.cancelPeripheralConnection(currentPeripheral)
            delegate?.didDiscover(model:BLEManagerDeviceModel(cbPeripheral: currentPeripheral))
        }
        
        self.currentPeripheral = connectToPeripheral
        
        manager?.connect(currentPeripheral!, options: nil)
        let model = BLEManagerDeviceModel(cbPeripheral: connectToPeripheral)
        delegate?.didDiscover(model:model)
    }
    
    func disconnect() {
        if let peripheral = currentPeripheral {
            manager?.cancelPeripheralConnection(peripheral)
        }
    }
}

extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            manager?.scanForPeripherals(withServices: nil, options: nil)
        default:
            PermissionHandler.showSettingsAlert(message: "AppAlert_Message_BLEPermission")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Peripheral name: \(peripheral.name ?? ""), state: \(peripheral.state.rawValue)")
        
        let model = BLEManagerDeviceModel(cbPeripheral: peripheral)
        delegate?.didDiscover(model: model)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral: \(peripheral.name ?? ""), error: \(error?.localizedDescription ?? "")")
        delegate?.didDiscover(model: BLEManagerDeviceModel(cbPeripheral: peripheral))
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect: \(peripheral.name ?? ""), error: \(error?.localizedDescription ?? "")")
        delegate?.didDiscover(model: BLEManagerDeviceModel(cbPeripheral: peripheral))
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        print("Connected to:\(peripheral.name!)")
        let model = BLEManagerDeviceModel(cbPeripheral: peripheral)
        delegate?.didDiscover(model: model)
    }
}

extension BLEManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {        
        guard let data = characteristic.value, data.count > 0 else {
            print("empty data")
            return
        }
        let model = BLEManagerDeviceModel(cbPeripheral: peripheral,
                                          value: characteristic.value?.hexEncodedString() ?? "")
        delegate?.didDiscover(model: model)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            print("Service found with UUID: " + service.uuid.uuidString)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard service.uuid.uuidString == uartService else { return }
        for characteristic in (service.characteristics ?? []) {
            guard characteristic.uuid.uuidString == uartCharacteristic else { continue }
            peripheral.setNotifyValue(true, for: characteristic)
            let model = BLEManagerDeviceModel(cbPeripheral: peripheral,
                                              value: characteristic.value?.hexEncodedString() ?? "")
            delegate?.didDiscover(model: model)
        }
    }
}


