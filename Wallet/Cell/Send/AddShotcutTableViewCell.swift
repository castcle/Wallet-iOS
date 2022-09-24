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
//  AddShotcutTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 24/9/2565 BE.
//

import UIKit
import Core

protocol AddShotcutTableViewCellDelegate: AnyObject {
    func didAddShortcut(_ addShotcutTableViewCell: AddShotcutTableViewCell)
}

class AddShotcutTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var addShortcutLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var addShortcutView: UIView!

    public var delegate: AddShotcutTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.white
        self.valueLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.valueLabel.textColor = UIColor.Asset.white
        self.addShortcutLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.addShortcutLabel.textColor = UIColor.Asset.lightBlue
        self.lineView.backgroundColor = UIColor.Asset.cellBackground
        self.addShortcutView.capsule(borderWidth: 1.0, borderColor: UIColor.Asset.lightBlue)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(title: String, value: String) {
        self.titleLabel.text = title
        self.valueLabel.text = value
    }

    @IBAction func addShortcut(_ sender: Any) {
        self.delegate?.didAddShortcut(self)
    }
}
