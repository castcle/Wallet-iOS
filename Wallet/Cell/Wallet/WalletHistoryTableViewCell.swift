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
//  WalletHistoryTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 27/7/2565 BE.
//

import UIKit
import Core
import Networking

class WalletHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionIcon: UIImageView!
    @IBOutlet weak var nextIcon: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var lineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.typeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.typeLabel.textColor = UIColor.Asset.white
        self.dateLabel.font = UIFont.asset(.contentLight, fontSize: .small)
        self.dateLabel.textColor = UIColor.Asset.white
        self.amountLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.amountLabel.textColor = UIColor.Asset.white
        self.statusLabel.font = UIFont.asset(.contentLight, fontSize: .small)
        self.statusLabel.textColor = UIColor.Asset.white
        self.nextIcon.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.lineView.backgroundColor = UIColor.Asset.lineGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(walletHistory: WalletHistory) {
        if( walletHistory.type == .deposit) || (walletHistory.type == .receive) {
            self.amountLabel.textColor = UIColor.Asset.trendUp
            self.typeLabel.text = walletHistory.type.display
            self.dateLabel.text = "\(walletHistory.transactionDate.dateToString()) \(walletHistory.transactionDate.timeToString())"
            self.amountLabel.text = "\(walletHistory.value) CAST"
            self.statusLabel.text = walletHistory.status.display
            self.transactionIcon.image = UIImage.init(icon: .castcle(.arowDown), size: CGSize(width: 50, height: 50), textColor: UIColor.Asset.trendUp)
        } else if (walletHistory.type == .send) || (walletHistory.type == .withdraw) {
            self.amountLabel.textColor = UIColor.Asset.trendDown
            self.typeLabel.text = walletHistory.type.display
            self.dateLabel.text = "\(walletHistory.transactionDate.dateToString()) \(walletHistory.transactionDate.timeToString())"
            self.amountLabel.text = "\(walletHistory.value) CAST"
            self.statusLabel.text = walletHistory.status.display
            self.transactionIcon.image = UIImage.init(icon: .castcle(.arowUp), size: CGSize(width: 50, height: 50), textColor: UIColor.Asset.trendDown)
        } else if walletHistory.type == .airdrop {
            self.amountLabel.textColor = (walletHistory.status == .failed ? UIColor.Asset.trendDown :  UIColor.Asset.lightBlue)
            self.typeLabel.text = walletHistory.type.display
            self.dateLabel.text = "\(walletHistory.transactionDate.dateToString()) \(walletHistory.transactionDate.timeToString())"
            self.amountLabel.text = "\(walletHistory.value) CAST"
            self.statusLabel.text = walletHistory.status.display
            self.transactionIcon.image = UIImage.init(icon: .castcle(.airdropBalloon), size: CGSize(width: 50, height: 50), textColor: UIColor.Asset.white)
        } else if walletHistory.type == .farming {
            self.transactionIcon.image = UIImage.init(icon: .castcle(.farm), size: CGSize(width: 50, height: 50), textColor: UIColor.Asset.lightBlue)
            self.typeLabel.text = walletHistory.type.display
            self.dateLabel.text = "\(walletHistory.transactionDate.dateToString()) \(walletHistory.transactionDate.timeToString())"
            self.amountLabel.text = " - \(walletHistory.value)"
            self.statusLabel.text = ""
            self.amountLabel.textColor = UIColor.Asset.denger
        } else if walletHistory.type == .unfarming {
            self.transactionIcon.image = UIImage.init(icon: .castcle(.farm), size: CGSize(width: 50, height: 50), textColor: UIColor.Asset.denger)
            self.typeLabel.text = walletHistory.type.display
            self.dateLabel.text = "\(walletHistory.transactionDate.dateToString()) \(walletHistory.transactionDate.timeToString())"
            self.amountLabel.text = "\(walletHistory.value)"
            self.statusLabel.text = ""
            self.amountLabel.textColor = UIColor.Asset.lightBlue
        } else if walletHistory.type == .farmed {
            self.transactionIcon.image = UIImage.init(icon: .castcle(.farm), size: CGSize(width: 50, height: 50), textColor: UIColor.Asset.white)
            self.typeLabel.text = walletHistory.type.display
            self.dateLabel.text = "\(walletHistory.transactionDate.dateToString()) \(walletHistory.transactionDate.timeToString())"
            self.amountLabel.text = "\(walletHistory.value)"
            self.statusLabel.text = ""
            self.amountLabel.textColor = UIColor.Asset.lightBlue
        } else {
            self.transactionIcon.image = UIImage()
            self.typeLabel.text = ""
            self.dateLabel.text = ""
            self.amountLabel.text = ""
            self.statusLabel.text = ""
        }
    }
}
