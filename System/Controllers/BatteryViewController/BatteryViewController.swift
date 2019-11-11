//
//  BatteryViewController.swift
//  System
//
//  Created by SangNX on 11/10/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class BatteryViewController: BaseViewController {
    @IBOutlet weak var vHeader: HeaderView!
    @IBOutlet weak var tbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.vHeader.setColorViewGradient(colorTop: UIColor(red:0.4, green:0.27, blue:0.74, alpha:1), colorBottom: UIColor(red:0.51, green:0.5, blue:0.92, alpha:1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.drawPieChart()
    }
    
    private func setUpView() {
        var subTitle = ""
        if let info = SystemMonitor.batteryInfoCtrl().getBatteryInfo() {
            subTitle = String(format: "%ld mAh", info.capacity)
        }
        vHeader.setTitleAndSubTitle(title: "Capacity", subTitle: subTitle)
    }
    
    private func setUpTableView() {
        tbView.tableFooterView = UIView()
        tbView.registerXibFile(BatteryTableViewCell.self)
        tbView.dataSource = self
    }
    
    private func drawPieChart() {
        let paragraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
        paragraphStyle.alignment = NSTextAlignment.center
        
        let useMemory = SystemValue.batteryLevel
        let title     = String(format: "%.0f%%", useMemory)
        
        let centerText = NSMutableAttributedString (string: title)
        centerText.setAttributes(
            [NSAttributedString.Key.font: UIFont (name: "HelveticaNeue-Bold", size: 36)!,
             NSAttributedString.Key.paragraphStyle: paragraphStyle,
             NSAttributedString.Key.foregroundColor: UIColor.white],
            range: NSMakeRange(0, title.count))
        
        self.vHeader.chartView.centerAttributedText = centerText
        
        let values = [Double(useMemory), Double(100 - useMemory)]
        let colors = [UIColor(red:0.49, green:0.91, blue:0.32, alpha:1),
                      UIColor(red:0.62, green:0.6, blue:0.87, alpha:1)]
        self.vHeader.drawPieData(values: values, colors: colors, enableCenterText: true)
    }
}

// MARK: - UITableViewDelegate & DataSource

extension BatteryViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbView.dequeueTableCell(BatteryTableViewCell.self)
        if let info = SystemMonitor.batteryInfoCtrl().getBatteryInfo() {
            switch indexPath.row {
            case 0:
                cell.lblTitle.text = "Battery Capacity"
                cell.lblDetail.text = String(format: "%ld",info.capacity)
                break
            case 1:
                cell.lblTitle.text = "Battery Voltage"
                cell.lblDetail.text = String (format: "%0.2f V", info.voltage)
                break
            case 2:
                cell.lblTitle.text = "Battery Status"
                cell.lblDetail.text = info.status
                break
            case 3:
                cell.lblTitle.text = "Battery Level"
                cell.lblDetail.text = String (format: "%0ld %% (%ld mAh)", info.levelPercent,
                    info.levelMAH)
                break
            default:
                break
            }
        }
        return cell
    }
}
