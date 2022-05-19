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
//  WalletViewController.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 17/5/2565 BE.
//

import UIKit
import Core
import Defaults
import FirebaseRemoteConfig

class WalletViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = WalletViewModel()

    enum WalletViewControllerSection: Int, CaseIterable {
        case displayName = 0
        case balance
        case transaction
        case banner
        case historyHeader
        case history
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
        self.customNavigationBar(.secondary, title: "Wallet")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.displayName, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.displayName)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.balance, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.balance)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.transaction, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.transaction)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.banner, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.banner)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.walletHistoryHeader, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.walletHistoryHeader)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.walletNoData, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.walletNoData)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return WalletViewControllerSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case WalletViewControllerSection.banner.rawValue:
            let airdropEnable = RemoteConfig.remoteConfig().configValue(forKey: "banner_early_airdrop_enable").boolValue
            if airdropEnable {
                return 1
            } else {
                return 0
            }
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case WalletViewControllerSection.displayName.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.displayName, for: indexPath as IndexPath) as? DisplayNameTableViewCell
            cell?.configCell(page: self.viewModel.page)
            cell?.backgroundColor = UIColor.clear
            cell?.delegate = self
            return cell ?? DisplayNameTableViewCell()
        case WalletViewControllerSection.balance.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.balance, for: indexPath as IndexPath) as? BalanceTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? BalanceTableViewCell()
        case WalletViewControllerSection.transaction.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.transaction, for: indexPath as IndexPath) as? TransactionTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? TransactionTableViewCell()
        case WalletViewControllerSection.banner.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.banner, for: indexPath as IndexPath) as? BannerTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? BannerTableViewCell()
        case WalletViewControllerSection.historyHeader.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.walletHistoryHeader, for: indexPath as IndexPath) as? WalletHistoryHeaderTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(type: self.viewModel.walletHistoryType)
            cell?.delegate = self
            return cell ?? WalletHistoryHeaderTableViewCell()
        case WalletViewControllerSection.history.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.walletNoData, for: indexPath as IndexPath) as? WalletNoDataTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(type: self.viewModel.walletHistoryType)
            return cell ?? WalletNoDataTableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

extension WalletViewController: DisplayNameTableViewCellDelegate {
    func didChoosePage(_ cell: DisplayNameTableViewCell) {
        let viewController = WalletOpener.open(.selectPage) as? SelectPageViewController
        viewController?.delegate = self
        let selectPageNani: UINavigationController = UINavigationController(rootViewController: viewController ?? SelectPageViewController())
        self.present(selectPageNani, animated: true)
    }
}

extension WalletViewController: WalletHistoryHeaderTableViewCellDelegate {
    func didChooseFilter(_ cell: WalletHistoryHeaderTableViewCell, type: WalletHistoryType) {
        self.viewModel.walletHistoryType = type
        self.tableView.reloadData()
    }
}

extension WalletViewController: SelectPageViewControllerDelegate {
    func didChoosePage(_ view: SelectPageViewController, page: Page) {
        self.viewModel.page = page
        self.tableView.reloadData()
    }
}