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
//  EditShortcutListTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 14/7/2565 BE.
//

import UIKit
import Core

protocol EditShortcutListTableViewCellDelegate: AnyObject {
    func didEditShortcut(_ editShortcutListTableViewCell: EditShortcutListTableViewCell, indexPath: IndexPath)
    func didDeleteShortcut(_ editShortcutListTableViewCell: EditShortcutListTableViewCell, indexPath: IndexPath)
}

class EditShortcutListTableViewCell: UITableViewCell {

    @IBOutlet weak var shortcutAvatarImage: UIImageView!
    @IBOutlet weak var shortcutTitleLabel: UILabel!
    @IBOutlet weak var shortcutLine: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    public var delegate: EditShortcutListTableViewCellDelegate?
    private var indexPath: IndexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.shortcutTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.shortcutLine.backgroundColor = UIColor.Asset.darkGray
        self.shortcutAvatarImage.circle(color: UIColor.Asset.white)
        self.editView.backgroundColor = UIColor.Asset.lightBlue
        self.deleteView.backgroundColor = UIColor.Asset.denger
        self.editButton.setImage(UIImage.init(icon: .castcle(.editNew), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.deleteButton.setImage(UIImage.init(icon: .castcle(.delete), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(avatar: String, castcleId: String, pageCastcleId: String, indexPath: IndexPath) {
        self.indexPath = indexPath
        if castcleId == pageCastcleId {
            self.shortcutTitleLabel.text = "@\(castcleId) (You)"
            self.shortcutTitleLabel.textColor = UIColor.Asset.lightBlue
        } else {
            self.shortcutTitleLabel.text = "@\(castcleId)"
            self.shortcutTitleLabel.textColor = UIColor.Asset.white
        }
        let shortcutAvatar = URL(string: avatar)
        self.shortcutAvatarImage.kf.setImage(with: shortcutAvatar, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
    }

    @IBAction func editButton(_ sender: Any) {
        self.delegate?.didEditShortcut(self, indexPath: self.indexPath)
    }

    @IBAction func deleteAction(_ sender: Any) {
        self.delegate?.didDeleteShortcut(self, indexPath: self.indexPath)
    }
}
