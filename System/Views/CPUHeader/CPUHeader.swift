//
//  CPUHeader.swift
//  System
//
//  Created by SangNX on 11/11/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

protocol CPUHeaderDelegate: class {
    func cpuUpdated(userAvr: Double, systemAvr: Double, niceAvr: Double)
}

class CPUHeader: BaseView, CPUInfoControllerDelegate {
    @IBOutlet weak var cpuUsageGLView: GLKView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var ViewGradient: UIView!
    private var glGraph: GLLineGraph?
    weak var delegate: CPUHeaderDelegate?
    
    override func firstInit() {
        setupBase()
        setupView()
    }
    
    func setupBase() {
        self.cpuUsageGLView?.isOpaque = false
        self.cpuUsageGLView?.backgroundColor = UIColor.clear
        self.glGraph = GLLineGraph (
            glkView: self.cpuUsageGLView,
            dataLineCount: 1,
            fromValue: 0,
            toValue: 100,
            topLegend: "100%")
        self.glGraph!.setDataLineLegendPostfix("%")
        self.glGraph!.preferredFramesPerSecond = 2
        SystemMonitor.cpuInfoCtrl().setCPULoadHistorySize((self.glGraph?.requiredElementToFill())!)
        
        // CPU Info
        let cpuInfo: CPUInfo = SystemMonitor.cpuInfoCtrl().getCPUInfo()
        self.titleLabel.text = String (format: "Total running Processes: %d", cpuInfo.activeCPUCount)
    }
    
    func setupView() {
        // Lấy lịch sử cpu
        guard let cpuLoadArray = SystemMonitor.cpuInfoCtrl().cpuLoadHistory else { return }
        let graphData = NSMutableArray (capacity: cpuLoadArray.count)
        var avr:Double = 0
        
        var userAvr:Double = 0
        var systemAvr:Double = 0
        var niceAvr:Double = 0
        
        if cpuLoadArray.count > 0 {
            for i in 0...cpuLoadArray.count - 1 {
                let data: NSArray = cpuLoadArray[i] as! NSArray
                avr = 0
                userAvr = 0
                systemAvr = 0
                niceAvr = 0
                
                for j in 0...data.count - 1 {
                    let load: CPULoad = data[j] as! CPULoad
                    avr += load.total
                    userAvr += load.user
                    systemAvr += load.system
                    niceAvr += load.nice
                }
                
                avr /= Double(data.count)
                userAvr /= Double(data.count)
                systemAvr /= Double(data.count)
                niceAvr /= Double(data.count)
                
                graphData.add([(avr)])
            }
        }
        
        // Draw cpu
        self.glGraph?.resetDataArray(graphData as [AnyObject])
        SystemMonitor.cpuInfoCtrl().delegate = self
    }
    
    func cpuLoadUpdated(_ loadArray: [Any]!) {
        var avr: Float = 0
        var userAvr:Float = 0
        var systemAvr:Float = 0
        var niceAvr:Float = 0
        
        for load in loadArray {
            avr += Float((load as AnyObject).total)
            userAvr += Float((load as AnyObject).user)
            systemAvr += Float((load as AnyObject).system)
            niceAvr += Float((load as AnyObject).nice)
        }
        avr /= Float(loadArray.count)
        userAvr /= Float(loadArray.count)
        systemAvr /= Float(loadArray.count)
        niceAvr /= Float(loadArray.count)
        
        // Update graphic
        self.glGraph!.addDataValue([(avr)])
        self.subTitleLabel.text = String(format: "Total CPU uses %.0f %%", avr)
        self.cpuUsageGLView.display()
        NSLog("value = %.1f - %0.1f - %0.1f", Float(userAvr), Float(systemAvr), Float(niceAvr))
        self.delegate?.cpuUpdated(userAvr: Double(userAvr), systemAvr: Double(systemAvr), niceAvr: Double(niceAvr))
    }

}
