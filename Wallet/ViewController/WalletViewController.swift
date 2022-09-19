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
import Networking
import Component
import Defaults
import FirebaseRemoteConfig
import PanModal

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
        self.tableView.coreRefresh.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            guard let self = self else { return }
            CCLoading.shared.show(text: "Loading")
            self.viewModel.walletLookup()
        }
        self.viewModel.didGetWalletLockupFinish = {
            CCLoading.shared.dismiss()
            self.tableView.coreRefresh.endHeaderRefresh()
            self.tableView.reloadData()
        }
        self.viewModel.didError = {
            CCLoading.shared.dismiss()
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ScreenId.wallet.rawValue
        CCLoading.shared.show(text: "Loading")
        self.viewModel.walletLookup()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        EngagementHelper().sendCastcleAnalytic(event: .onScreenView, screen: .wallet)
        self.sendAnalytics()
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Wallet")
        var rightButton: [UIBarButtonItem] = []
        let scanIcon = NavBarButtonType.qrCode.barButton
        scanIcon.addTarget(self, action: #selector(self.scanAction), for: .touchUpInside)
        rightButton.append(UIBarButtonItem(customView: scanIcon))
        self.navigationItem.rightBarButtonItems = rightButton
    }

    private func sendAnalytics() {
        let item = Analytic()
        item.accountId = UserManager.shared.accountId
        item.userId = UserManager.shared.id
        TrackingAnalyticHelper.shared.sendTrackingAnalytic(eventType: .viewWallet, item: item)
    }

    @objc private func scanAction() {
        self.navigationController?.pushViewController(WalletOpener.open(.scanQrCode(ScanQrCodeViewModel(scanType: .all, page: self.viewModel.page, wallet: self.viewModel.wallet))), animated: true)
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.displayName, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.displayName)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.balance, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.balance)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.transaction, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.transaction)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.banner, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.banner)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.walletHistoryHeader, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.walletHistoryHeader)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.walletHistory, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.walletHistory)
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
        case WalletViewControllerSection.history.rawValue:
            if !self.viewModel.history.isEmpty {
                return self.viewModel.history.count
            } else {
                return 1
            }
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case WalletViewControllerSection.displayName.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.displayName, for: indexPath as IndexPath) as? DisplayNameTableViewCell
            cell?.configCell(page: self.viewModel.page, isDisplayOnly: false)
            cell?.backgroundColor = UIColor.clear
            cell?.delegate = self
            return cell ?? DisplayNameTableViewCell()
        case WalletViewControllerSection.balance.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.balance, for: indexPath as IndexPath) as? BalanceTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(wallet: self.viewModel.wallet)
            return cell ?? BalanceTableViewCell()
        case WalletViewControllerSection.transaction.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.transaction, for: indexPath as IndexPath) as? TransactionTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(page: self.viewModel.page, wallet: self.viewModel.wallet)
            return cell ?? TransactionTableViewCell()
        case WalletViewControllerSection.banner.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.banner, for: indexPath as IndexPath) as? BannerTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? BannerTableViewCell()
        case WalletViewControllerSection.historyHeader.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.walletHistoryHeader, for: indexPath as IndexPath) as? WalletHistoryHeaderTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(type: self.viewModel.walletRequest.filter)
            cell?.delegate = self
            return cell ?? WalletHistoryHeaderTableViewCell()
        case WalletViewControllerSection.history.rawValue:
            if !self.viewModel.history.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.walletHistory, for: indexPath as IndexPath) as? WalletHistoryTableViewCell
                cell?.backgroundColor = UIColor.Asset.cellBackground
                cell?.configCell(walletHistory: self.viewModel.history[indexPath.row])
                return cell ?? WalletHistoryTableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.walletNoData, for: indexPath as IndexPath) as? WalletNoDataTableViewCell
                cell?.backgroundColor = UIColor.clear
                cell?.configCell(type: self.viewModel.walletRequest.filter)
                return cell ?? WalletNoDataTableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
}

extension WalletViewController: DisplayNameTableViewCellDelegate {
    func didChoosePage(_ cell: DisplayNameTableViewCell) {
        let viewController = WalletOpener.open(.selectPage(SelectPageViewModel(selectPage: self.viewModel.page, enableCancel: true))) as? SelectPageViewController
        viewController?.delegate = self
        Utility.currentViewController().presentPanModal(viewController ?? SelectPageViewController())
    }
}

extension WalletViewController: WalletHistoryHeaderTableViewCellDelegate {
    func didChooseFilter(_ cell: WalletHistoryHeaderTableViewCell, type: WalletHistoryType) {
        if type != self.viewModel.walletRequest.filter {
            self.viewModel.walletRequest.filter = type
            self.tableView.reloadData()
            CCLoading.shared.show(text: "Loading")
            self.viewModel.getWalletHistory()
        }
    }
}

extension WalletViewController: SelectPageViewControllerDelegate {
    func didChoosePage(_ view: SelectPageViewController, page: PageRealm) {
        self.viewModel.page = page
        self.tableView.reloadData()
    }
}
