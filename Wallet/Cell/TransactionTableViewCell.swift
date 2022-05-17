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
//  TransactionTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 17/5/2565 BE.
//

import UIKit
import Core

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var buyView: UIView!
    @IBOutlet weak var sendLabel: UILabel!
    @IBOutlet weak var depositLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.sendLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.sendLabel.textColor = UIColor.Asset.white
        self.depositLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.depositLabel.textColor = UIColor.Asset.white
        self.buyLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.buyLabel.textColor = UIColor.Asset.white
        self.sendView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 5)
        self.depositView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 5)
        self.buyView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
