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
//  SendWalletViewController.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 29/6/2565 BE.
//

import UIKit
import Core
import Networking
import Defaults

class SendWalletViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var reciveAmountLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!

    var viewModel = SendWalletViewModel(wallet: Wallet())
    var isAvtive: Bool {
        if self.viewModel.walletRequest.address.isEmpty || self.viewModel.walletRequest.amount.isEmpty {
            return false
        } else {
            return true
        }
    }
    enum SendWalletViewControllerSection: Int, CaseIterable {
        case shortcuts = 0
        case sendDetail
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.configureTableView()
        self.totalView.backgroundColor = UIColor.Asset.cellBackground
        self.reciveAmountLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.reciveAmountLabel.textColor = UIColor.Asset.white
        self.castLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.castLabel.textColor = UIColor.Asset.lightBlue
        self.feeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.feeLabel.textColor = UIColor.Asset.white
        self.sendButton.activeButton(isActive: false, fontSize: .overline)
        self.viewModel.didGetWalletShortcutsFinish = {
            self.tableView.reloadData()
        }
        self.viewModel.didReviewSendTokenFinish = {
            Utility.currentViewController().navigationController?.pushViewController(WalletOpener.open(.sendReview(SendReviewViewModel(walletRequest: self.viewModel.walletRequest, page: self.viewModel.page))), animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
        self.viewModel.getWalletShortcuts()
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Send")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.sendShortcut, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.sendShortcut)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.sendTo, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.sendTo)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    @IBAction func sendAction(_ sender: Any) {
        if self.isAvtive {
            let amount: Double = Double(self.viewModel.walletRequest.amount) ?? 0
            if (amount <= 0) || (amount > self.viewModel.wallet.availableBalance) || (self.viewModel.wallet.availableBalance <= 0) {
                ApiHelper.displayMessage(title: "Warning", message: "** You have insufficient balance", buttonTitle: "Close")
            } else {
                self.viewModel.reviewSendToken()
            }
        }
    }
}

extension SendWalletViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SendWalletViewControllerSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if SendWalletViewControllerSection.shortcuts.rawValue == indexPath.section {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.sendShortcut, for: indexPath as IndexPath) as? SendShortcutTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.delegate = self
            cell?.configCell(shortcuts: self.viewModel.myShortcut, page: self.viewModel.page)
            return cell ?? SendShortcutTableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.sendTo, for: indexPath as IndexPath) as? SendToTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.delegate = self
            cell?.configCell(sendTo: self.viewModel.walletRequest.castcleId, page: self.viewModel.page, wallet: self.viewModel.wallet)
            return cell ?? SendToTableViewCell()
        }
    }
}

extension SendWalletViewController: SendShortcutTableViewCellDelegate {
    func didSelectShortcut(_ sendShortcutTableViewCell: SendShortcutTableViewCell, shortcut: Shortcut) {
        self.viewModel.walletRequest.address = shortcut.userId
        self.viewModel.walletRequest.castcleId = shortcut.castcleId
        self.sendButton.activeButton(isActive: self.isAvtive, fontSize: .overline)
        self.tableView.reloadData()
    }

    func didManageShortcut(_ sendShortcutTableViewCell: SendShortcutTableViewCell) {
        Utility.currentViewController().navigationController?.pushViewController(WalletOpener.open(.manageShortcuts(ManageShortcutsViewModel(page: self.viewModel.page))), animated: true)
    }
}

extension SendWalletViewController: SendToTableViewCellDelegate {
    func didSelectWalletsRecent(_ sendToTableViewCell: SendToTableViewCell, walletsRecent: WalletsRecent) {
        self.viewModel.walletRequest.address = walletsRecent.id
        self.viewModel.walletRequest.castcleId = walletsRecent.castcleId
        self.sendButton.activeButton(isActive: self.isAvtive, fontSize: .overline)
    }

    func didValueChange(_ sendToTableViewCell: SendToTableViewCell, memo: String, amount: String, note: String) {
        self.viewModel.walletRequest.memo = memo
        self.viewModel.walletRequest.amount = amount
        self.viewModel.walletRequest.note = note
        self.castLabel.text = "\(self.viewModel.walletRequest.amount) CAST"
        self.sendButton.activeButton(isActive: self.isAvtive, fontSize: .overline)
    }

    func didScanWalletSuccess(_ sendToTableViewCell: SendToTableViewCell, chainId: String, userId: String, castcleId: String) {
        self.viewModel.walletRequest.chainId = chainId
        self.viewModel.walletRequest.address = userId
        self.viewModel.walletRequest.castcleId = castcleId
        self.sendButton.activeButton(isActive: self.isAvtive, fontSize: .overline)
    }

    func didScanTextSuccess(_ sendToTableViewCell: SendToTableViewCell, text: String) {
        self.viewModel.walletRequest.memo = text
    }
}
