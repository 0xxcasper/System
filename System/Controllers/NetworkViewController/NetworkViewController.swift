//
//  NetworkViewController.swift
//  System
//
//  Created by SangNX on 11/10/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class NetworkViewController: BaseViewController {
    // MARK: - View Elements
    @IBOutlet weak var vHeader: HeaderView!
    @IBOutlet weak var lblReceived: UILabel!
    @IBOutlet weak var lblSend: UILabel!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var vCircleWifi: UIView!
    @IBOutlet weak var vCircle3G: UIView!
    
    // MARK: - Properties
    private var dataWifi = ["MAC Address:", SystemValue.wiFiRouterAddress,
                          "IP Address: " + (SystemValue.wiFiIPAddress ?? ""),
                          "Data Send: " + NetworkHelper.shared.getWifiDataSend(),
                          "Data Received: " + NetworkHelper.shared.getWifiDataReceived()]
    
    private var data3G = ["MAC Address:", SystemValue.currentIPAddress,
                          "IP Address: " + (SystemValue.cellIPAddress ?? ""),
                          "Data Send: " + NetworkHelper.shared.getWWANDataSend(),
                          "Data Received: " + NetworkHelper.shared.getWWANDataReceived()]
    
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.vHeader.setColorViewGradient(colorTop: UIColor(red:0.93, green:0.35, blue:0.58, alpha:1), colorBottom: UIColor(red:0.21, green:0.28, blue:0.52, alpha:1))
        self.vCircleWifi.cornerCircleView()
        self.vCircle3G.cornerCircleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        self.drawPieChart()
    }
}

// MARK: - Private's Method

private extension NetworkViewController {
    
    func setUpView() {
        if !(SystemValue.connectedToCellNetwork || SystemValue.connectedToWiFi) {
            vHeader.setTitleAndSubTitle(title: "NOT CONNECT", subTitle: "You are not connected to the internet")
            self.vCircle3G.backgroundColor = UIColor(red:1, green:0.23, blue:0.19, alpha:1)
            self.vCircleWifi.backgroundColor = UIColor(red:1, green:0.23, blue:0.19, alpha:1)
        } else {
            vHeader.setTitleAndSubTitle(title: "CONNECTED", subTitle: "You are connected to the internet")
        }
        if SystemValue.connectedToCellNetwork == true {
            self.vCircle3G.backgroundColor   = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1)
            
            self.lblReceived.text = NetworkHelper.shared.getWWANDataReceived()
            self.lblSend.text = NetworkHelper.shared.getWWANDataSend()
        } else {
            self.vCircle3G.backgroundColor   = UIColor(red:1, green:0.23, blue:0.19, alpha:1)
        }
        
        if SystemValue.connectedToWiFi == true {
            self.vCircleWifi.backgroundColor = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1)
            
            self.lblReceived.text = NetworkHelper.shared.getWifiDataReceived()
            self.lblSend.text = NetworkHelper.shared.getWifiDataSend()
        } else {
            self.vCircleWifi.backgroundColor = UIColor(red:1, green:0.23, blue:0.19, alpha:1)
        }
    }
    
    func setUpTableView() {
         let foolterView = UIView()
        foolterView.backgroundColor = self.tbView.backgroundColor
        self.tbView.tableFooterView = foolterView
        self.tbView.rowHeight = 44
        self.tbView.registerXibFile(NetworkTableViewCell.self)
        self.tbView.dataSource = self
        self.tbView.separatorStyle = .none
        self.tbView.isScrollEnabled = false
    }
    
    func drawPieChart() {
        let networkDataCounters: NSArray = SystemUtilities.getNetworkDataCounters()! as NSArray
        var wwanSent     =  (networkDataCounters[2] as! NSNumber).floatValue
        var wwanReceived = (networkDataCounters[3] as! NSNumber).floatValue

        if SystemValue.connectedToWiFi == true {
            wwanSent     =  (networkDataCounters[0] as! NSNumber).floatValue
            wwanReceived = (networkDataCounters[1] as! NSNumber).floatValue
        }
        let wwanSentPercent = (wwanSent * 100)/(wwanSent + wwanReceived)
        
        let values = [Double(wwanSentPercent), Double(100 - wwanSentPercent)]
        
        let colors = [UIColor(red:0.55, green:0.68, blue:0.88, alpha:1),
                      UIColor(red:0.99, green:0.75, blue:0.33, alpha:1)]
        self.vHeader.drawPieData(values: values, colors: colors, enableCenterText: true)
    }
}

// MARK: - UITableViewDelegate & DataSource

extension NetworkViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataWifi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tbView.dequeueTableCell(NetworkTableViewCell.self)
        cell.lblTitle.text = dataWifi[indexPath.row]
        cell.lblSubTitle.text = data3G[indexPath.row]
        return cell
    }
}
