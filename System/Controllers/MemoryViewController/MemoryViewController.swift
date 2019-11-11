//
//  MemoryViewController.swift
//  System
//
//  Created by SangNX on 11/10/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class MemoryViewController: BaseViewController {
    // MARK: - View Elements
    @IBOutlet weak var vHeader: HeaderView!
    @IBOutlet weak var lblUsedMemory: UILabel!
    @IBOutlet weak var lblFreeMemory: UILabel!
    @IBOutlet weak var tbView: UITableView!
    
    // MARK: - Properties
    private let colors = [ UIColor(red:0.65, green:0.64, blue:0.99, alpha:1),
                           UIColor(red:0.36, green:0.89, blue:1, alpha:1),
                           UIColor(red:0.99, green:0.75, blue:0.33, alpha:1),
                           UIColor(red:0.39, green:0.38, blue:0.87, alpha:1)]
    
    private let titles = ["Active", "Wired", "Inactive", "Free"]
    
    private let percents = [String(format: "%.1f%%",SystemValue.activeMemoryinPercent),
                          String(format: "%.1f%%",SystemValue.wiredMemoryinPercent),
                          String(format: "%.1f%%",SystemValue.inactiveMemoryinPercent),
                          String(format: "%.1f%%",SystemValue.freeMemoryinPercent)]
    
    private let values = [String(format: "%.0f MB",SystemValue.activeMemoryinRaw),
                          String(format: "%.0f MB",SystemValue.wiredMemoryinRaw),
                          String(format: "%.0f MB",SystemValue.inactiveMemoryinRaw),
                          String(format: "%.0f MB",SystemValue.freeMemoryinRaw)]

    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.vHeader.setColorViewGradient(colorTop: UIColor(red:0.53, green:0.44, blue:0.76, alpha:1), colorBottom: UIColor(red:0.21, green:0.28, blue:0.52, alpha:1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.drawPieChart()
    }
}

// MARK: - Private's Method

private extension MemoryViewController {
    
    func setUpView() {
        lblFreeMemory.text = String (format: "%.0f MB",SystemValue.freeMemoryinRaw)
        lblUsedMemory.text = String (format: "%.0f MB",SystemValue.usedMemoryinRaw)
        vHeader.setTitleAndSubTitle(title: String (format: "(±)%.2f MB", SystemValue.totalMemory), subTitle: "Memory")
    }
    
    func setUpTableView() {
        tbView.tableFooterView = UIView()
        tbView.registerXibFile(MemoryTableViewCell.self)
        tbView.rowHeight = 60
        tbView.dataSource = self
    }
    
    func drawPieChart() {
        let active   = SystemValue.activeMemoryinPercent
        let wired    = SystemValue.wiredMemoryinPercent
        let inactive = SystemValue.inactiveMemoryinPercent
        let free     = SystemValue.freeMemoryinPercent
        
        let values = [Double(active), Double(wired), Double(inactive), Double(free)]
        self.vHeader.drawPieData(values: values, colors: colors)
    }
}

// MARK: - UITableViewDelegate & DataSource

extension MemoryViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbView.dequeueTableCell(MemoryTableViewCell.self)
        cell.setupViewCell(color: colors[indexPath.row], title: titles[indexPath.row], value: values[indexPath.row], percent: percents[indexPath.row])
        return cell
    }
}
