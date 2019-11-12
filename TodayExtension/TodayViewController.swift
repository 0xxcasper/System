//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by admin on 12/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit
import NotificationCenter
import Charts

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var vPieChart: PieChartView!
    
    // MARK: - Properties
    private let colors = [ UIColor(red:0.65, green:0.64, blue:0.99, alpha:1),
                           UIColor(red:0.36, green:0.89, blue:1, alpha:1),
                           UIColor(red:0.99, green:0.75, blue:0.33, alpha:1),
                           UIColor(red:0.39, green:0.38, blue:0.87, alpha:1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.setupPie()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drawPieChart()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    private func setupPie() {
        self.vPieChart.usePercentValuesEnabled = false
        self.vPieChart.holeRadiusPercent = 0.78
        self.vPieChart.transparentCircleRadiusPercent = 0
        self.vPieChart.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        self.vPieChart.drawCenterTextEnabled = true
    }
    
    private func drawPieChart() {
        let SystemValue = SystemServices()
        let active   = SystemValue.activeMemoryinPercent
        let wired    = SystemValue.wiredMemoryinPercent
        let inactive = SystemValue.inactiveMemoryinPercent
        let free     = SystemValue.freeMemoryinPercent
        
        let title    = String(format: "%.0f MB \n Free", SystemValue.freeMemoryinRaw)
        
        self.vPieChart.centerText = title
        
        let values = [Double(active), Double(wired), Double(inactive), Double(free)]
        self.drawPieData(values: values, colors: colors, enableCenterText: true)
    }
    
    private func drawPieData(values: [Double], colors: [UIColor], enableCenterText: Bool = false) {
        self.vPieChart.usePercentValuesEnabled = true
        self.vPieChart.drawCenterTextEnabled = enableCenterText
        self.vPieChart.rotationAngle = 90
        self.vPieChart.rotationEnabled = true
        
        let l:Legend = self.vPieChart.legend
        l.enabled = false
        self.vPieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: ChartEasingOption.easeOutBack)
        
        // Set data
        var dataEntries: Array<BarChartDataEntry> = Array()
        for i: Int in 0...values.count - 1 {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.colors = colors
        DispatchQueue.main.async {
            let data = PieChartData(dataSet: dataSet)
            self.vPieChart.data = data
            self.vPieChart.highlightValues(nil)
        }
    }
}
