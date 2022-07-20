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
//  VerifyAccountTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 1/7/2565 BE.
//

import UIKit
import Core

class VerifyAccountTableViewCell: UITableViewCell {

    @IBOutlet var settingTitleLabel: UILabel!
    @IBOutlet var settingDisplayLabel: UILabel!
    @IBOutlet var settingNoteLabel: UILabel!
    @IBOutlet var settingNextImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.settingTitleLabel.textColor = UIColor.Asset.white
        self.settingDisplayLabel.font = UIFont.asset(.contentLight, fontSize: .body)
        self.settingNoteLabel.font = UIFont.asset(.contentLight, fontSize: .small)
        self.settingNoteLabel.textColor = UIColor.Asset.denger
        self.settingNextImage.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(section: VerifyAccountSection) {
        self.settingTitleLabel.text = section.text
        if section == .email {
            if UserManager.shared.email.isEmpty {
                self.settingDisplayLabel.textColor = UIColor.Asset.unregistered
                self.settingDisplayLabel.text = "Unregistered"
                self.settingNoteLabel.text = ""
                self.settingNextImage.isHidden = false
            } else if !UserManager.shared.isVerifiedEmail {
                self.settingDisplayLabel.textColor = UIColor.Asset.textGray
                self.settingDisplayLabel.text = UserManager.shared.email
                self.settingNoteLabel.text = "Please verify you email"
                self.settingNextImage.isHidden = false
            } else {
                self.settingDisplayLabel.textColor = UIColor.Asset.textGray
                self.settingDisplayLabel.text = UserManager.shared.email
                self.settingNoteLabel.text = ""
                self.settingNextImage.isHidden = true
            }
        } else if section == .mobile {
            if UserManager.shared.isVerifiedMobile {
                self.settingDisplayLabel.text = "Registered"
                self.settingNoteLabel.text = ""
                self.settingNextImage.isHidden = true
                self.settingDisplayLabel.textColor = UIColor.Asset.lightBlue
            } else {
                self.settingDisplayLabel.text = "Unregistered"
                self.settingNoteLabel.text = ""
                self.settingNextImage.isHidden = false
                self.settingDisplayLabel.textColor = UIColor.Asset.unregistered
            }
        } else {
            self.settingDisplayLabel.text = ""
            self.settingNoteLabel.text = ""
            self.settingNextImage.isHidden = false
        }
    }
}
