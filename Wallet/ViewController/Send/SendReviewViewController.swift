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
//  SendReviewViewController.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 30/6/2565 BE.
//

import UIKit
import Core
import Component
import Defaults

class SendReviewViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = SendReviewViewModel()

    enum SendReviewViewControllerSection: Int, CaseIterable {
        case data = 0
        case note
        case confirm
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
        self.viewModel.didRequestOtpFinish = {
            if self.viewModel.isSendEmailOtp && self.viewModel.isSendMobileOtp {
                CCLoading.shared.dismiss()
                Utility.currentViewController().navigationController?.pushViewController(WalletOpener.open(.sendAuth(self.viewModel)), animated: true)
            }
        }
        self.viewModel.didError = {
            CCLoading.shared.dismiss()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Send")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.reviewSend, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.reviewSend)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.reviewData, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.reviewData)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.reviewNote, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.reviewNote)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.sendConfiem, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.sendConfiem)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension SendReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SendReviewViewControllerSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SendReviewViewControllerSection.data.rawValue:
            return self.viewModel.sendReview.count
        case SendReviewViewControllerSection.note.rawValue:
            return (self.viewModel.walletRequest.note.isEmpty ? 0 : 1)
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SendReviewViewControllerSection.data.rawValue:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.reviewSend, for: indexPath as IndexPath) as? ReviewSendTableViewCell
                cell?.backgroundColor = UIColor.clear
                cell?.configCell(totalAmount: self.viewModel.walletRequest.amount)
                return cell ?? ReviewSendTableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.reviewData, for: indexPath as IndexPath) as? ReviewDataTableViewCell
                cell?.backgroundColor = UIColor.clear
                let data = self.viewModel.sendReview[indexPath.row]
                cell?.configCell(title: data.title, value: data.value)
                return cell ?? ReviewDataTableViewCell()
            }
        case SendReviewViewControllerSection.note.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.reviewNote, for: indexPath as IndexPath) as? ReviewNoteTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(note: self.viewModel.walletRequest.note)
            return cell ?? ReviewNoteTableViewCell()
        case SendReviewViewControllerSection.confirm.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.sendConfiem, for: indexPath as IndexPath) as? SendConfiemTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(isActive: true)
            cell?.delegate = self
            return cell ?? SendConfiemTableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

extension SendReviewViewController: SendConfiemTableViewCellDelegate {
    func didConfirm(_ sendConfiemTableViewCell: SendConfiemTableViewCell) {
        self.viewModel.authenRequest.objective = AuthenObjective.sendToken
        self.viewModel.authenRequest.email = UserManager.shared.email
        self.viewModel.authenRequest.countryCode = UserManager.shared.countryCode
        self.viewModel.authenRequest.mobileNumber = UserManager.shared.mobile
        CCLoading.shared.show(text: "Sending")
        self.viewModel.requestOtpWithEmail()
        self.viewModel.requestOtpWithMobile()
    }
}
