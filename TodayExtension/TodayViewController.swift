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
    // MARK: - View Elements
    @IBOutlet weak var heightAnchorChart: NSLayoutConstraint!
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var vPieChart: PieChartView!
    @IBOutlet weak var tbView: UITableView!
    
    // MARK: - Properties
    private var SystemValue = SystemServices()
    private let colors = [ UIColor(red:0.65, green:0.64, blue:0.99, alpha:1),
                           UIColor(red:0.36, green:0.89, blue:1, alpha:1),
                           UIColor(red:0.99, green:0.75, blue:0.33, alpha:1),
                           UIColor(red:0.39, green:0.38, blue:0.87, alpha:1)]
    private let titles = ["Active", "Wired", "Inactive", "Free"]
       
    private var percents = ["","","",""]
       
    private var values = ["","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .compact
        self.setupPie()
        self.setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewGradient.setGradientBackground(colorTop: UIColor(red:0.53, green:0.44, blue:0.76, alpha:1), colorBottom: UIColor(red:0.21, green:0.28, blue:0.52, alpha:1))
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            heightAnchorChart.constant = 200
            preferredContentSize = CGSize(width: 0.0, height: 445.0)
        } else {
            heightAnchorChart.constant = 110
            preferredContentSize = maxSize
        }
        updateData()
        view.layoutIfNeeded()
        viewGradient.setGradientBackground(colorTop: UIColor(red:0.53, green:0.44, blue:0.76, alpha:1), colorBottom: UIColor(red:0.21, green:0.28, blue:0.52, alpha:1))
    }
}

// MARK: - Private's Method

private extension TodayViewController {
    
    func updateData() {
        SystemValue = SystemServices()
        percents = [String(format: "%.1f%%",SystemValue.activeMemoryinPercent),
                    String(format: "%.1f%%",SystemValue.wiredMemoryinPercent),
                    String(format: "%.1f%%",SystemValue.inactiveMemoryinPercent),
                    String(format: "%.1f%%",SystemValue.freeMemoryinPercent)]
           
        values = [String(format: "%.0f MB",SystemValue.activeMemoryinRaw),
                    String(format: "%.0f MB",SystemValue.wiredMemoryinRaw),
                    String(format: "%.0f MB",SystemValue.inactiveMemoryinRaw),
                    String(format: "%.0f MB",SystemValue.freeMemoryinRaw)]
        self.drawPieChart()
        self.tbView.reloadData()
    }
    
    func setupPie() {
        self.vPieChart.usePercentValuesEnabled = false
        self.vPieChart.holeRadiusPercent = 0.78
        self.vPieChart.transparentCircleRadiusPercent = 0
        self.vPieChart.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        self.vPieChart.drawCenterTextEnabled = true
    }
    
    func setUpTableView() {
//        tbView.backgroundColor = .white
        tbView.tableFooterView = UIView()
        tbView.register(UINib(nibName: "MemoryTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tbView.rowHeight = 27.5
        tbView.dataSource = self
    }
    
    func drawPieChart() {
        let active   = SystemValue.activeMemoryinPercent
        let wired    = SystemValue.wiredMemoryinPercent
        let inactive = SystemValue.inactiveMemoryinPercent
        let free     = SystemValue.freeMemoryinPercent
        
        let title    = String(format: "%.0f MB \n Free", SystemValue.freeMemoryinRaw)
        
        self.vPieChart.centerText = title
        
        let values = [Double(active), Double(wired), Double(inactive), Double(free)]
        self.drawPieData(values: values, colors: colors, enableCenterText: true)
    }
    
    func drawPieData(values: [Double], colors: [UIColor], enableCenterText: Bool = false) {
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

// MARK: - UITableViewDelegate & DataSource

extension TodayViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MemoryTableViewCell
        cell.setupViewCell(color: colors[indexPath.row], title: titles[indexPath.row], value: values[indexPath.row], percent: percents[indexPath.row])
        return cell
    }
}

extension UIView {
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

