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
//  WalletHistoryHeaderTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 17/5/2565 BE.
//

import UIKit
import Core
import Component

protocol WalletHistoryHeaderTableViewCellDelegate: AnyObject {
    func didChooseFilter(_ cell: WalletHistoryHeaderTableViewCell, type: WalletHistoryType)
}

class WalletHistoryHeaderTableViewCell: UITableViewCell {

    @IBOutlet var filterLabel: UILabel!
    @IBOutlet var filterIcon: UIImageView!

    var delegate: WalletHistoryHeaderTableViewCellDelegate?
    var walletHistoryType: WalletHistoryType = .walletBalance

    override func awakeFromNib() {
        super.awakeFromNib()
        self.filterLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.filterLabel.textColor = UIColor.Asset.white
        self.filterIcon.image = UIImage.init(icon: .castcle(.settings), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(type: WalletHistoryType) {
        self.walletHistoryType = type
        self.filterLabel.text = type.display
    }

    @IBAction func filterAction(_ sender: Any) {
        let actionSheet = CCActionSheet()
        let walletButton = CCAction(title: WalletHistoryType.walletBalance.display, color: (self.walletHistoryType == .walletBalance ? UIColor.Asset.lightBlue : UIColor.Asset.white)) {
            actionSheet.dismissActionSheet()
            self.filterLabel.text =  WalletHistoryType.walletBalance.rawValue
            self.delegate?.didChooseFilter(self, type: .walletBalance)
        }
        let farmingButton = CCAction(title: WalletHistoryType.contentFarming.display, color: (self.walletHistoryType == .contentFarming ? UIColor.Asset.lightBlue : UIColor.Asset.white)) {
            actionSheet.dismissActionSheet()
            self.filterLabel.text =  WalletHistoryType.contentFarming.rawValue
            self.delegate?.didChooseFilter(self, type: .contentFarming)
        }
        let socialButton = CCAction(title: WalletHistoryType.socialRewards.display, color: (self.walletHistoryType == .socialRewards ? UIColor.Asset.lightBlue : UIColor.Asset.white)) {
            actionSheet.dismissActionSheet()
            self.filterLabel.text =  WalletHistoryType.socialRewards.rawValue
            self.delegate?.didChooseFilter(self, type: .socialRewards)
        }
        let transactionButton = CCAction(title: WalletHistoryType.depositSend.display, color: (self.walletHistoryType == .depositSend ? UIColor.Asset.lightBlue : UIColor.Asset.white)) {
            actionSheet.dismissActionSheet()
            self.filterLabel.text =  WalletHistoryType.depositSend.rawValue
            self.delegate?.didChooseFilter(self, type: .depositSend)
        }
        let airdropButton = CCAction(title: WalletHistoryType.airdropReferral.display, color: (self.walletHistoryType == .airdropReferral ? UIColor.Asset.lightBlue : UIColor.Asset.white)) {
            actionSheet.dismissActionSheet()
            self.filterLabel.text =  WalletHistoryType.airdropReferral.rawValue
            self.delegate?.didChooseFilter(self, type: .airdropReferral)
        }
        let cancelButton = CCAction(title: "Cancel", color: UIColor.Asset.denger) {
            actionSheet.dismissActionSheet()
        }

        actionSheet.addActions([walletButton, farmingButton, socialButton, transactionButton, airdropButton, cancelButton])
        Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
    }
}
