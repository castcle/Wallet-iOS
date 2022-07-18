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
import JGProgressHUD

class ManageShortcutsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private let hud = JGProgressHUD()
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
        self.viewModel.didGetWalletShortcutsFinish = {
            self.hud.dismiss()
            self.tableView.reloadData()
        }
        self.viewModel.didSortShortcutsFinish = {
            self.hud.dismiss()
            self.tableView.reloadData()
        }
        self.viewModel.didDeleteShortcutsFinish = {
            self.hud.dismiss()
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: self.view)
        self.viewModel.getWalletShortcuts()
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Shortcut")
        self.setupRightBarButton(isEditing: self.tableView.isEditing)
    }

    private func setupRightBarButton(isEditing: Bool) {
        var rightButton: [UIBarButtonItem] = []
        let icon = UIButton()
        icon.setTitle(isEditing ? "Save" : "Edit", for: .normal)
        icon.titleLabel?.font = UIFont.asset(.regular, fontSize: .body)
        icon.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        icon.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        rightButton.append(UIBarButtonItem(customView: icon))
        self.navigationItem.rightBarButtonItems = rightButton
    }

    @objc private func editAction() {
        guard self.viewModel.loadState == .loaded else { return }
        if self.tableView.isEditing {
            self.tableView.isEditing = false
            self.setupRightBarButton(isEditing: false)
            self.hud.textLabel.text = "Saving"
            self.hud.show(in: self.view)
            self.viewModel.sortShortcuts()
        } else {
            self.tableView.isEditing = true
            self.setupRightBarButton(isEditing: true)
            self.tableView.reloadData()
        }
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.manageShortcutHeader, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.manageShortcutHeader)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.shortcut, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.shortcut)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.editShortcutList, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.editShortcutList)
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
            return (tableView.isEditing ? 0 : 1)
        case ManageShortcutsViewControllerSection.myAccount.rawValue:
            return (tableView.isEditing ? 0 : self.viewModel.accounts.count)
        case ManageShortcutsViewControllerSection.shortcutHeader.rawValue:
            return 1
        case ManageShortcutsViewControllerSection.shortcut.rawValue:
            return self.viewModel.shortcuts.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case ManageShortcutsViewControllerSection.myAccountHeader.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.manageShortcutHeader, for: indexPath as IndexPath) as? ManageShortcutHeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
            cell?.configCell(title: "My account", hiddenAddShortcut: true)
            return cell ?? ManageShortcutHeaderTableViewCell()
        case ManageShortcutsViewControllerSection.myAccount.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.shortcut, for: indexPath as IndexPath) as? ShortcutTableViewCell
            let account = self.viewModel.accounts[indexPath.row]
            cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
            cell?.configCell(avatar: account.images.avatar.thumbnail, castcleId: account.castcleId, pageCastcleId: self.viewModel.page.castcleId)
            return cell ?? ShortcutTableViewCell()
        case ManageShortcutsViewControllerSection.shortcutHeader.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.manageShortcutHeader, for: indexPath as IndexPath) as? ManageShortcutHeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
            cell?.configCell(title: "Shortcut list", hiddenAddShortcut: tableView.isEditing)
            cell?.delegate = self
            return cell ?? ManageShortcutHeaderTableViewCell()
        case ManageShortcutsViewControllerSection.shortcut.rawValue:
            if tableView.isEditing {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.editShortcutList, for: indexPath as IndexPath) as? EditShortcutListTableViewCell
                let account = self.viewModel.shortcuts[indexPath.row]
                cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                cell?.configCell(avatar: account.images.avatar.thumbnail, castcleId: account.castcleId, pageCastcleId: self.viewModel.page.castcleId, indexPath: indexPath)
                cell?.delegate = self
                return cell ?? EditShortcutListTableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.shortcut, for: indexPath as IndexPath) as? ShortcutTableViewCell
                let account = self.viewModel.shortcuts[indexPath.row]
                cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                cell?.configCell(avatar: account.images.avatar.thumbnail, castcleId: account.castcleId, pageCastcleId: self.viewModel.page.castcleId)
                return cell ?? ShortcutTableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == ManageShortcutsViewControllerSection.shortcut.rawValue {
            return true
        } else {
            return false
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == ManageShortcutsViewControllerSection.shortcut.rawValue {
            return true
        } else {
            return false
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempShortcut = self.viewModel.shortcuts[sourceIndexPath.row]
        self.viewModel.shortcuts.remove(at: sourceIndexPath.row)
        self.viewModel.shortcuts.insert(tempShortcut, at: destinationIndexPath.row)
    }
}

extension ManageShortcutsViewController: ManageShortcutHeaderTableViewCellDelegate {
    func didAddShortcut(_ manageShortcutHeaderTableViewCell: ManageShortcutHeaderTableViewCell) {
        Utility.currentViewController().navigationController?.pushViewController(WalletOpener.open(.createShortcut(CreateShortcutViewModel(page: self.viewModel.page))), animated: true)
    }
}

extension ManageShortcutsViewController: EditShortcutListTableViewCellDelegate {
    func didEditShortcut(_ editShortcutListTableViewCell: EditShortcutListTableViewCell, indexPath: IndexPath) {
        let shortcut = self.viewModel.shortcuts[indexPath.row]
        Utility.currentViewController().navigationController?.pushViewController(WalletOpener.open(.createShortcut(CreateShortcutViewModel(page: self.viewModel.page, shortcut: shortcut))), animated: true)
    }

    func didDeleteShortcut(_ editShortcutListTableViewCell: EditShortcutListTableViewCell, indexPath: IndexPath) {
        self.hud.textLabel.text = "Deleting"
        self.hud.show(in: self.view)
        let shortcut = self.viewModel.shortcuts[indexPath.row]
        self.viewModel.deleteShortcut(deleteShortcut: shortcut)
        self.viewModel.shortcuts.remove(at: indexPath.row)
    }
}
