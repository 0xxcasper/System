//
//  CPUViewController.swift
//  System
//
//  Created by SangNX on 11/10/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit
import Charts

class CPUViewController: BaseViewController, CPUHeaderDelegate {
    
    @IBOutlet weak var cpuView: CPUHeader!
    
    @IBOutlet weak var userChartView: PieChartView!
    @IBOutlet weak var systemChartView: PieChartView!
    @IBOutlet weak var niceChartView: PieChartView!

    private var userColor = UIColor(red:0.34, green:0.89, blue:0.79, alpha:1)
    private var systemColor = UIColor(red:0.61, green:0.62, blue:0.98, alpha:1)
    private var niceColor = UIColor(red:0.99, green:0.75, blue:0.33, alpha:1)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        cpuView.delegate = self
        DispatchQueue.main.async {
            self.cpuView.ViewGradient.setGradientBackground(colorTop: UIColor(red:0.45, green:0.44, blue:0.87, alpha:1), colorBottom: UIColor(red:0.38, green:0.67, blue:0.69, alpha:1))

        }
    }
    
    func setupView() {
        // Setup chart view
        self.setupChartView(chartView: self.userChartView)
        self.setupChartView(chartView: self.systemChartView)
        self.setupChartView(chartView: self.niceChartView)

        self.userChartView.backgroundColor = UIColor.white
        self.systemChartView.backgroundColor = UIColor.white
        self.niceChartView.backgroundColor = UIColor.white

    }

    func cpuUpdated(userAvr: Double, systemAvr: Double, niceAvr: Double) {
        // Draw chart view
        self.drawChartView(chartView: self.userChartView, value: Double(userAvr), color: self.userColor)
        self.drawChartView(chartView: self.systemChartView, value: Double(systemAvr), color: self.systemColor)
        self.drawChartView(chartView: self.niceChartView, value: Double(niceAvr), color: self.niceColor)
    }
    
    // MARK: - Helper
    private func setupChartView(chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.holeRadiusPercent = 0.85
        chartView.transparentCircleRadiusPercent = 0
        chartView.setExtraOffsets(left: -10, top: -10, right: -10, bottom: -10)
        chartView.drawCenterTextEnabled = true
        chartView.holeColor = UIColor.clear
    }
        
    private func drawChartView(chartView: PieChartView, value: Double, color: UIColor) {
        // Draw text
        let paragraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = NSTextAlignment.center

        let title = String (format: "%.0f%%", Float(value))
        
        let centerText = NSMutableAttributedString (string: title)
        centerText.setAttributes(
            [NSAttributedString.Key.font: UIFont (name: "HelveticaNeue-Bold", size: 18)!,
             NSAttributedString.Key.paragraphStyle: paragraphStyle,
             NSAttributedString.Key.foregroundColor: color],
            range: NSMakeRange(0, title.count))
        chartView.centerAttributedText = centerText
        chartView.rotationAngle = 90
        chartView.rotationEnabled = true
        
        let l:Legend = chartView.legend
        l.enabled = false
        
        // Set data
        let values = [Double(value), Double(100 - value)]
        var dataEntries: Array<BarChartDataEntry> = Array()
        for i: Int in 0...values.count - 1 {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: values[i]))
        }
        let dataSet = PieChartDataSet(entries: dataEntries, label: "Test")
        dataSet.drawValuesEnabled = false
        dataSet.colors = [color, UIColor(red:0.88, green:0.88, blue:0.89, alpha:1)]
        DispatchQueue.main.async {
            let data = PieChartData(dataSet: dataSet)
            chartView.data = data
            chartView.highlightValues(nil)
        }
    }

}
