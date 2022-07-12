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
//  SendShortcutTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 29/6/2565 BE.
//

import UIKit
import Core
import Networking

protocol SendShortcutTableViewCellDelegate: AnyObject {
    func didSelectShortcut(_ sendShortcutTableViewCell: SendShortcutTableViewCell, shortcut: Shortcut)
    func didManageShortcut(_ sendShortcutTableViewCell: SendShortcutTableViewCell)
}

class SendShortcutTableViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var shortcutTitleLabel: UILabel!
    @IBOutlet weak var manageButton: UIButton!

    public var delegate: SendShortcutTableViewCellDelegate?
    private var shortcuts: [Shortcut] = []
    private var page: Page = Page()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.shortcutTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.shortcutTitleLabel.textColor = UIColor.Asset.white
        self.manageButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .body)
        self.manageButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.collectionView.register(UINib(nibName: WalletNibVars.CollectionViewCell.shortcut, bundle: ConfigBundle.wallet), forCellWithReuseIdentifier: WalletNibVars.CollectionViewCell.shortcut)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(shortcuts: [Shortcut], page: Page) {
        self.shortcuts = shortcuts
        self.page = page
        self.collectionView.reloadData()
    }

    @IBAction func manageAction(_ sender: Any) {
        self.delegate?.didManageShortcut(self)
    }
}

extension SendShortcutTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.shortcuts.count + 1)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == self.shortcuts.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalletNibVars.CollectionViewCell.shortcut, for: indexPath as IndexPath) as? ShortcutCollectionViewCell
            cell?.configCell(isAdd: true, castcleId: "", avatar: "")
            return cell ?? ShortcutCollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalletNibVars.CollectionViewCell.shortcut, for: indexPath as IndexPath) as? ShortcutCollectionViewCell
            let shortcut = self.shortcuts[indexPath.row]
            cell?.configCell(isAdd: false, castcleId: shortcut.castcleId, avatar: shortcut.images.avatar.thumbnail)
            return cell ?? ShortcutCollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != self.shortcuts.count {
            self.delegate?.didSelectShortcut(self, shortcut: self.shortcuts[indexPath.row])
        } else {
            Utility.currentViewController().navigationController?.pushViewController(WalletOpener.open(.createShortcut(CreateShortcutViewModel(page: self.page))), animated: true)
        }
    }
}
