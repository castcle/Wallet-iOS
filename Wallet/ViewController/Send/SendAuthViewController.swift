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
//  SendAuthViewController.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 30/6/2565 BE.
//

import UIKit
import Core
import Component
import Defaults

class SendAuthViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = SendReviewViewModel()
    var isAvtive: Bool {
        if (self.viewModel.walletRequest.emailOtp.count == 6) && (self.viewModel.walletRequest.mobileOtp.count == 6) {
            return true
        } else {
            return false
        }
    }
    enum SendAuthViewControllerSection: Int, CaseIterable {
        case verify = 0
        case confirm
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.configureTableView()
        self.viewModel.didSendTokenFinish = {
            CCLoading.shared.dismiss()
            let viewControllers: [UIViewController] = Utility.currentViewController().navigationController!.viewControllers as [UIViewController]
            Utility.currentViewController().navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
        }
        self.viewModel.didRequestOtpFinish = {
            CCLoading.shared.dismiss()
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
        self.customNavigationBar(.secondary, title: "Authentication")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.sendVerify, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.sendVerify)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.sendConfiem, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.sendConfiem)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension SendAuthViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SendAuthViewControllerSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if SendAuthViewControllerSection.verify.rawValue == indexPath.section {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.sendVerify, for: indexPath as IndexPath) as? SendVerifyTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(email: self.viewModel.walletRequest.email, mobile: "(\(self.viewModel.walletRequest.countryCode)) \(self.viewModel.walletRequest.mobileNumber)")
            cell?.delegate = self
            return cell ?? SendVerifyTableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.sendConfiem, for: indexPath as IndexPath) as? SendConfiemTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(isActive: self.isAvtive)
            cell?.delegate = self
            return cell ?? SendConfiemTableViewCell()
        }
    }
}

extension SendAuthViewController: SendVerifyTableViewCellDelegate {
    func didValueChange(_ sendVerifyTableViewCell: SendVerifyTableViewCell, verifyEmail: String, verifySms: String) {
        if (verifyEmail.count == 6) && (verifySms.count == 6) {
            self.viewModel.walletRequest.emailOtp = verifyEmail
            self.viewModel.walletRequest.mobileOtp = verifySms
            let indexPath = IndexPath(item: 0, section: 1)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    func didResendOtpEmail(_ sendVerifyTableViewCell: SendVerifyTableViewCell) {
        CCLoading.shared.show(text: "Sending")
        self.viewModel.requestOtpWithEmail()
    }

    func didResendOtpMobile(_ sendVerifyTableViewCell: SendVerifyTableViewCell) {
        CCLoading.shared.show(text: "Sending")
        self.viewModel.requestOtpWithMobile()
    }
}

extension SendAuthViewController: SendConfiemTableViewCellDelegate {
    func didConfirm(_ sendConfiemTableViewCell: SendConfiemTableViewCell) {
        if self.isAvtive {
            CCLoading.shared.show(text: "Sending")
            self.viewModel.confirmSendToken()
        }
    }
}
