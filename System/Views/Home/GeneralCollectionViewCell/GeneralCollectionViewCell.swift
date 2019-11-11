//
//  GeneralCollectionViewCell.swift
//  System
//
//  Created by admin on 11/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class GeneralCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tbView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red:0.89, green:0.88, blue:0.9, alpha:1).cgColor
        setUpTableView()
    }
    
    private func setUpTableView() {
        tbView.registerXibFile(GeneralTableViewCell.self)
        tbView.dataSource = self
        tbView.delegate = self
    }

    // MARK: - UITableViewDelegate & DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbView.dequeueTableCell(GeneralTableViewCell.self)
        switch indexPath.row {
        case 0:
            cell.lblTitle.text = "Device:"
            cell.lblDetail.text = SystemValue.systemDeviceTypeNotFormatted
            break
        case 1:
            cell.lblTitle.text = "Model:"
            cell.lblDetail.text = SystemValue.deviceModel
            break
        case 2:
            cell.lblTitle.text = "OS:"
            cell.lblDetail.text = SystemValue.systemsVersion
            break
        case 3:
            cell.lblTitle.text = "Boot at:"
            let now = NSDate(timeIntervalSince1970: Double(SystemMonitor.deviceInfo().bootTime))
            let calendar = NSCalendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now as Date)
            let dateString = String(format: "%04ld-%02ld-%02ld %ld:%02ld:%02ld", dateComponents.year!, dateComponents.month!, dateComponents.day!, dateComponents.hour!, dateComponents.minute!, dateComponents.second!)
            cell.lblDetail.text = dateString
            break
        default:
            break
        }
        return cell
    }
}
