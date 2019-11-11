//
//  CPUCollectionViewCell.swift
//  System
//
//  Created by admin on 11/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit
import Foundation

class CPUCollectionViewCell: UICollectionViewCell, CPUInfoControllerDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cpuUsageGLView: GLKView!
    
    private var glGraph: GLLineGraph?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red:0.89, green:0.88, blue:0.9, alpha:1).cgColor
        
        self.cpuUsageGLView?.isOpaque = false
        self.cpuUsageGLView?.backgroundColor = UIColor.clear
        
        self.glGraph = GLLineGraph(
            glkView: self.cpuUsageGLView,
            dataLineCount: 1,
            fromValue: 0,
            toValue: 100,
            topLegend: "100%")
        self.glGraph?.setDataLineLegendPostfix("%")
        
        SystemMonitor.cpuInfoCtrl().setCPULoadHistorySize((self.glGraph?.requiredElementToFill())!)
    }
    
    func reloadData() {
        guard let cpuLoadArray = SystemMonitor.cpuInfoCtrl().cpuLoadHistory else { return }
        let graphData = NSMutableArray (capacity: cpuLoadArray.count)
        var avr:Double = 0
        
        if cpuLoadArray.count > 0 {
            for i in 0...cpuLoadArray.count - 1 {
                let data: NSArray = cpuLoadArray[i] as! NSArray
                avr = 0
                
                for j in 0...data.count - 1 {
                    let load: CPULoad = data[j] as! CPULoad
                    avr += load.total
                }
                
                avr /= Double(data.count)
                graphData.add([(avr)])
            }
        }
        self.glGraph?.resetDataArray(graphData as [AnyObject])
        SystemMonitor.cpuInfoCtrl().delegate = self
    }
    
    func cpuLoadUpdated(_ loadArray: [Any]!) {
        var avr: Double = 0
        for load in loadArray {
            avr += (load as AnyObject).total
        }
        avr /= Double(loadArray.count)
        self.glGraph?.addDataValue([(avr)])
        self.lblTitle.text = String(format: "Usage %.0f %%", avr)
        self.cpuUsageGLView.display()
    }
}
