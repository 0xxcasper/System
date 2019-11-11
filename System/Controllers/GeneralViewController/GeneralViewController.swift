//
//  GeneralViewController.swift
//  System
//
//  Created by SangNX on 11/10/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController {

    @IBOutlet weak var tbView: UITableView!
    
    private let gererals = ["Owner Name", "Device", "Model", "Device OS", "Boot Time", "OS Build", "OS Revision", "Kernal" ,"Carrier Name", "Language"]
    private let valueGererals = [SystemValue.systemName, SystemValue.systemDeviceTypeNotFormatted,                                       SystemValue.deviceModel, SystemValue.systemsVersion,
                                 Double(SystemMonitor.deviceInfo().bootTime).toBootTimeString(),
                                 SystemMonitor.deviceInfo().osBuild,
                                 String(format: "%d", SystemMonitor.deviceInfo().osRevision),
                                 SystemMonitor.deviceInfo().kernelInfo,
                                 SystemValue.carrierName, SystemValue.language]

    private let hardwares = ["Camera", "Accessories Attached" ,"Headphone Attached", "Retina", "Retina HD"]
    private var valueHardwares = ["", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueHardwares = [ UIImagePickerController.isSourceTypeAvailable(.camera) ? "YES" : "NO",
                           SystemValue.accessoriesAttached ? "YES" : "NO",
                           SystemValue.headphonesAttached ? "YES" : "NO",
                           SystemMonitor.deviceInfo().retina ? "YES" : "NO",
                           SystemMonitor.deviceInfo().retinaHD ? "YES" : "NO",]
        setUpTableView()
    }
}

// MARK: - Private's Method

private extension GeneralViewController {
    
    func setUpView() {
        self.title = "General info"
    }
    
    func setUpTableView() {
        tbView.tableFooterView = UIView()
        tbView.registerXibFile(BatteryTableViewCell.self)
        tbView.rowHeight = 60
        tbView.sectionHeaderHeight = 60
        tbView.dataSource = self
    }
}

// MARK: - UITableViewDelegate & DataSource

extension GeneralViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? gererals.count : hardwares.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbView.dequeueTableCell(BatteryTableViewCell.self)
        if indexPath.section == 0 {
            cell.lblDetail.text = valueGererals[indexPath.row]
            cell.lblTitle.text = gererals[indexPath.row]
        } else {
            cell.lblDetail.text = valueHardwares[indexPath.row]
            cell.lblTitle.text = hardwares[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "General info" : "Hardware Info"
    }
}
