//
//  MemoryTableViewCell.swift
//  TodayExtension
//
//  Created by admin on 12/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class MemoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var vValue: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vValue.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupViewCell( color: UIColor, title: String, value: String, percent: String ) {
        vValue.backgroundColor = color
        lblTitle.text = title
        lblPercent.text = percent
        lblValue.text = value
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
    }
    
}
