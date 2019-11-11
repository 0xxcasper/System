//
//  DiskViewController.swift
//  System
//
//  Created by SangNX on 11/10/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit
import SVProgressHUD
import Photos
import PhotosUI

class DiskViewController: BaseViewController {
    // MARK: - View Elements
    @IBOutlet weak var vHeader: HeaderView!
    @IBOutlet weak var lblUsedSpace: UILabel!
    @IBOutlet weak var lblFreeSpace: UILabel!
    @IBOutlet weak var tbView: UITableView!
    
    // MARK: - Properties
    private var storageInfo: StorageInfo?
    private var numOfRows = 0
    
    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.vHeader.setColorViewGradient(colorTop: UIColor(red:0.23, green:0.86, blue:0.82, alpha:1), colorBottom: UIColor(red:0.54, green:0.35, blue:0.85, alpha:1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.drawPieChart()
        self.getStorageInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                if status != PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Permission require", message: "Please enable photo permission access in setting", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Setting", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }))
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    self.storageInfo = SystemMonitor.storageInfoCtrl().getStorageInfo()
                }
            })
        }
    }
}

// MARK: - Private's Method

private extension DiskViewController {
    
    func getStorageInfo() {
        DispatchQueue.global(qos: .background).async {
            SystemMonitor.storageInfoCtrl().delegate = self
            self.storageInfo = SystemMonitor.storageInfoCtrl().getStorageInfo()
            if self.storageInfo!.totalPictureSize != 0 {
                DispatchQueue.main.async {
                    SVProgressHUD.show(withStatus: "updating")
                }
            }
        }
    }
    
    func setUpView() {
        self.lblFreeSpace.text = SSDiskInfo.freeDiskSpace(false)
        self.lblUsedSpace.text = SSDiskInfo.usedDiskSpace(false)
        vHeader.setTitleAndSubTitle(title: SSDiskInfo.diskSpace() ?? "", subTitle: "Total disk space")
    }
    
    func setUpTableView() {
        tbView.tableFooterView = UIView()
        tbView.registerXibFile(BatteryTableViewCell.self)
        tbView.rowHeight = 60
        tbView.dataSource = self
    }
    
    func drawPieChart() {
        let freeDisk = Float(SystemValue.longFreeDiskSpace)/1024/1024
        let fullDisk = Float(SystemValue.longDiskSpace)/1024/1024
        let freeDisPercent = Float((freeDisk * 100))/fullDisk;
        
        let values = [Double(freeDisPercent), Double(100 - freeDisPercent)]
        let colors = [UIColor(red:0.37, green:0.89, blue:0.8, alpha:1),
                      UIColor(red:0.55, green:0.68, blue:0.88, alpha:1)]
        self.vHeader.drawPieData(values: values, colors: colors)
    }
}


// MARK: - UITableViewDelegate's Method

extension DiskViewController: UITableViewDataSource, StorageInfoControllerDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbView.dequeueTableCell(BatteryTableViewCell.self)
        switch indexPath.row {
        case 0:
            cell.lblTitle.text = "Number of Songs"
            cell.lblDetail.text = String(format: "%lu", self.storageInfo!.songCount)
            break
        case 1:
            cell.lblTitle.text = "Number of Pictures"
            cell.lblDetail.text = String(format: "%lu (%@)", self.storageInfo!.pictureCount,                    AMUtils.toNearestMetric(self.storageInfo!.totalPictureSize, desiredFraction: 1))
            break
        case 2:
            cell.lblTitle.text = "Number of Videos"
            cell.lblDetail.text = String(format: "%lu (%@)", self.storageInfo!.videoCount,
                    AMUtils.toNearestMetric(self.storageInfo!.totalVideoSize, desiredFraction: 1))
            break
        default:
            break
        }
        return cell
    }
    
    // MARK: - StorageInfoControllerDelegate
    
    func storageInfoUpdated() {
        self.numOfRows = 3
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.tbView.reloadData()
        }
    }
}
