//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  BalanceTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 17/5/2565 BE.
//

import UIKit
import Core
import Networking
import GTProgressBar

class BalanceTableViewCell: UITableViewCell {

    @IBOutlet weak var barView: GTProgressBar!
    @IBOutlet weak var totalBalanceTitle: UILabel!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var moreIcon: UIImageView!
    @IBOutlet weak var farmBalanceTitle: UILabel!
    @IBOutlet weak var farmBalance: UILabel!
    @IBOutlet weak var availBalanceTitle: UILabel!
    @IBOutlet weak var availBalance: UILabel!
    @IBOutlet weak var farmView: UIView!
    @IBOutlet weak var availView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.barView.progress = 0.5
        self.barView.barBorderColor = UIColor.clear
        self.barView.barFillColor = UIColor.Asset.lightBlue
        self.barView.barBackgroundColor = UIColor.Asset.veryLightBlue
        self.barView.barBorderWidth = 0
        self.barView.barFillInset = 0
        self.barView.cornerRadius = -1
        self.barView.displayLabel = false
        self.totalBalanceTitle.font = UIFont.asset(.regular, fontSize: .body)
        self.totalBalanceTitle.textColor = UIColor.Asset.white
        self.totalBalance.font = UIFont.asset(.regular, fontSize: .body)
        self.totalBalance.textColor = UIColor.Asset.white
        self.farmBalance.font = UIFont.asset(.regular, fontSize: .body)
        self.farmBalance.textColor = UIColor.Asset.white
        self.availBalance.font = UIFont.asset(.regular, fontSize: .body)
        self.availBalance.textColor = UIColor.Asset.white
        self.farmBalanceTitle.font = UIFont.asset(.regular, fontSize: .small)
        self.farmBalanceTitle.textColor = UIColor.Asset.white
        self.availBalanceTitle.font = UIFont.asset(.regular, fontSize: .small)
        self.availBalanceTitle.textColor = UIColor.Asset.white
        self.farmView.backgroundColor = UIColor.Asset.lightBlue
        self.availView.backgroundColor = UIColor.Asset.veryLightBlue
        self.moreIcon.image = UIImage.init(icon: .castcle(.aboutUs), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(wallet: Wallet) {
        self.totalBalance.text = "\(wallet.totalBalance) CAST"
        self.farmBalance.text = "\(wallet.farmBalance) CAST"
        self.availBalance.text = "\(wallet.availableBalance) CAST"
        if (wallet.farmBalanceNumber + wallet.availableBalanceNumber) == 0 {
            self.barView.progress = 0.5
        } else {
            self.barView.progress = CGFloat(wallet.farmBalanceNumber / (wallet.farmBalanceNumber + wallet.availableBalanceNumber))
        }
    }
}
