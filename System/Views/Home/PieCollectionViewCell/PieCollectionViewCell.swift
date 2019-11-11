//
//  PieCollectionViewCell.swift
//  System
//
//  Created by admin on 11/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit
import Charts

class PieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var vChart: PieChartView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red:0.89, green:0.88, blue:0.9, alpha:1).cgColor
        
        self.vChart.isUserInteractionEnabled = false
        self.setupPie()
    }
    
    func setPieData (title: String, subTitle: String, values: [Double], colors: [UIColor]) {
        // Draw text
        let paragraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = NSTextAlignment.center
        
        let centerText = NSMutableAttributedString (string: title + "\n" + subTitle)
        centerText.setAttributes(
            [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!,
             NSAttributedString.Key.paragraphStyle: paragraphStyle,
             NSAttributedString.Key.foregroundColor: UIColor(red:0.25, green:0.24, blue:0.29, alpha:1)],
            range: NSMakeRange(0, title.count))
        centerText.setAttributes(
            [NSAttributedString.Key.font: UIFont (name: "HelveticaNeue", size: 12)!,
             NSAttributedString.Key.paragraphStyle: paragraphStyle,
             NSAttributedString.Key.foregroundColor: UIColor(red:0.25, green:0.24, blue:0.29, alpha:1)],
            range: NSMakeRange(title.count, centerText.length - title.count))
        self.vChart.centerAttributedText = centerText
        self.vChart.rotationAngle = 90
        self.vChart.rotationEnabled = true
        
        let l:Legend = self.vChart.legend
        l.enabled = false
        self.vChart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: ChartEasingOption.easeOutBack)

        // Set data
        var dataEntries: Array<BarChartDataEntry> = Array()
        for i: Int in 0...values.count - 1 {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "Test")
        dataSet.drawValuesEnabled = false
        dataSet.colors = colors
        
        let data = PieChartData(dataSet: dataSet)
        self.vChart.data = data
        self.vChart.highlightValues(nil)
    }
    
    private func setupPie() {
        self.vChart.usePercentValuesEnabled = false
        self.vChart.holeRadiusPercent = 0.78
        self.vChart.transparentCircleRadiusPercent = 0
        self.vChart.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        self.vChart.drawCenterTextEnabled = true
    }
}
