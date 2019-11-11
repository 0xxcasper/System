//
//  NetworkHelper.swift
//  System
//
//  Created by admin on 11/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import Foundation

class NetworkHelper {
    
    static let shared = NetworkHelper()
    
    func getWWANDataReceived() -> String {
        let networkDataCounters: NSArray = SystemUtilities.getNetworkDataCounters()! as NSArray
        var wwanReceived = (networkDataCounters[3] as! NSNumber).floatValue
        
        var receivedUnit = "KB"
        if wwanReceived > 1024 {
            wwanReceived = wwanReceived/1024
            receivedUnit = "MB"
        }
        if wwanReceived > 1024 {
            wwanReceived = wwanReceived/1024
            receivedUnit = "GB"
        }
        return String(format: "%.1f %@",wwanReceived, receivedUnit)
    }
    
    func getWWANDataSend() -> String {
        let networkDataCounters: NSArray = SystemUtilities.getNetworkDataCounters()! as NSArray
        var wwanSent     =  (networkDataCounters[2] as! NSNumber).floatValue
        
        var sendUnit = "KB"
        if wwanSent > 1024 {
            wwanSent = wwanSent/1024
            sendUnit = "MB"
        }
        if wwanSent > 1024 {
            wwanSent = wwanSent/1024
            sendUnit = "GB"
        }
        return String(format: "%.1f %@",wwanSent, sendUnit)
    }
    
    func getWifiDataReceived() -> String {
        let networkDataCounters: NSArray = SystemUtilities.getNetworkDataCounters()! as NSArray
        var wwanReceived = (networkDataCounters[1] as! NSNumber).floatValue
        
        var receivedUnit = "KB"
        if wwanReceived > 1024 {
            wwanReceived = wwanReceived/1024
            receivedUnit = "MB"
        }
        if wwanReceived > 1024 {
            wwanReceived = wwanReceived/1024
            receivedUnit = "GB"
        }
        return String(format: "%.1f %@",wwanReceived, receivedUnit)
    }
    
    func getWifiDataSend() -> String {
        let networkDataCounters: NSArray = SystemUtilities.getNetworkDataCounters()! as NSArray
        var wwanSent     =  (networkDataCounters[0] as! NSNumber).floatValue
        
        var sendUnit = "KB"
        if wwanSent > 1024 {
            wwanSent = wwanSent/1024
            sendUnit = "MB"
        }
        if wwanSent > 1024 {
            wwanSent = wwanSent/1024
            sendUnit = "GB"
        }
        return String(format: "%.1f %@",wwanSent, sendUnit)
    }
}
