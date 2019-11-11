//
//  HeaderView.swift
//  System
//
//  Created by SangNX on 11/10/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit
import Charts

class HeaderView: BaseView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var viewGradient: UIView!
    
    override func firstInit() {
        setupPie()
    }
    
    private func setupPie() {
        self.chartView.usePercentValuesEnabled = true
        self.chartView.holeRadiusPercent = 0.75
        self.chartView.transparentCircleRadiusPercent = 0
        self.chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        self.chartView.drawCenterTextEnabled = true
        self.chartView.holeColor = UIColor.clear
    }
    
    func setTitleAndSubTitle( title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    func setColorViewGradient( colorTop: UIColor, colorBottom: UIColor) {
        viewGradient.setGradientBackground(colorTop: colorTop, colorBottom: colorBottom)
    }

    func drawPieData(values: [Double], colors: [UIColor], enableCenterText: Bool = false) {
        self.chartView.usePercentValuesEnabled = true
        self.chartView.drawCenterTextEnabled = enableCenterText
        self.chartView.rotationAngle = 90
        self.chartView.rotationEnabled = true
        
        let l:Legend = self.chartView.legend
        l.enabled = false
        self.chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)
        
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
            self.chartView.data = data
            self.chartView.highlightValues(nil)
        }
    }
}
