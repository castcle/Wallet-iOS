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
//  ManageShortcutsViewController.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 8/7/2565 BE.
//

import UIKit
import Core
import Defaults

class ManageShortcutsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = ManageShortcutsViewModel()
    enum ManageShortcutsViewControllerSection: Int, CaseIterable {
        case myAccountHeader = 0
        case myAccount
        case shortcutHeader
        case shortcut
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Shortcut")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.manageShortcutHeader, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.manageShortcutHeader)
//        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.sendConfiem, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.sendConfiem)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension ManageShortcutsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ManageShortcutsViewControllerSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case ManageShortcutsViewControllerSection.myAccountHeader.rawValue:
            return 1
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case ManageShortcutsViewControllerSection.myAccountHeader.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.manageShortcutHeader, for: indexPath as IndexPath) as? ManageShortcutHeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
            cell?.configCell(title: "My account", hiddenAddShortcut: true)
            return cell ?? ManageShortcutHeaderTableViewCell()
        case ManageShortcutsViewControllerSection.shortcutHeader.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.manageShortcutHeader, for: indexPath as IndexPath) as? ManageShortcutHeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
            cell?.configCell(title: "Shortcut list", hiddenAddShortcut: false)
            return cell ?? ManageShortcutHeaderTableViewCell()
        default:
            return UITableViewCell()
        }
    }
}
