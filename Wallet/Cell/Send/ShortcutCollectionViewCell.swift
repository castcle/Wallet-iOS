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
//  ShortcutCollectionViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 30/6/2565 BE.
//

import UIKit
import Core
import Kingfisher

class ShortcutCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarShortImage: UIImageView!
    @IBOutlet weak var addIcon: UIImageView!
    @IBOutlet weak var nameShortcutLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameShortcutLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.nameShortcutLabel.textColor = UIColor.Asset.white
        self.addIcon.image = UIImage.init(icon: .castcle(.add), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue)
    }

    func configCell(isAdd: Bool, castcleId: String, avatar: String) {
        if isAdd {
            self.addIcon.isHidden = false
            self.avatarShortImage.image = UIImage()
            self.avatarShortImage.circle(color: UIColor.Asset.lightBlue)
            self.nameShortcutLabel.text = "Add"
        } else {
            self.addIcon.isHidden = true
            self.avatarShortImage.circle(color: UIColor.Asset.white)
            self.nameShortcutLabel.text = "@\(castcleId)"
            let shortcutAvatar = URL(string: avatar)
            self.avatarShortImage.kf.setImage(with: shortcutAvatar, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        }
    }
}
