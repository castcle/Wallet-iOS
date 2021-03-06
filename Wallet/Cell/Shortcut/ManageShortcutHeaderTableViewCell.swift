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
//  ManageShortcutHeaderTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 8/7/2565 BE.
//

import UIKit
import Core

protocol ManageShortcutHeaderTableViewCellDelegate: AnyObject {
    func didAddShortcut(_ manageShortcutHeaderTableViewCell: ManageShortcutHeaderTableViewCell)
}

class ManageShortcutHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addShortcutButton: UIButton!

    public var delegate: ManageShortcutHeaderTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.white
        self.addShortcutButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.addShortcutButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(title: String, hiddenAddShortcut: Bool) {
        self.titleLabel.text = title
        self.addShortcutButton.isHidden = hiddenAddShortcut
    }

    @IBAction func addShortcutAction(_ sender: Any) {
        self.delegate?.didAddShortcut(self)
    }
}
