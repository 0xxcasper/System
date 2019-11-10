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
}
