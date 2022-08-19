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
//  WalletVerifyAccountViewController.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 1/7/2565 BE.
//

import UIKit
import Core
import Component
import Defaults

class WalletVerifyAccountViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    enum WalletVerifyAccountViewControllerSection: Int, CaseIterable {
        case setting = 0
        case note
    }

    var viewModel = WalletVerifyAccountViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
        self.viewModel.didGetMeFinish = {
            CCLoading.shared.dismiss()
            self.tableView.reloadData()
        }

        self.viewModel.didError = {
            CCLoading.shared.dismiss()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
        CCLoading.shared.show(text: "Loading")
        self.viewModel.getMe()
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Account Setting")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.verifyAccount, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.verifyAccount)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.notice, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.notice)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension WalletVerifyAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return WalletVerifyAccountViewControllerSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == WalletVerifyAccountViewControllerSection.setting.rawValue {
            return self.viewModel.verifySection.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == WalletVerifyAccountViewControllerSection.setting.rawValue {
            return (self.viewModel.verifySection.count > 0 ? 50 : 0)
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
        label.font = UIFont.asset(.light, fontSize: .overline)
        label.textColor = UIColor.Asset.textGray
        if section == WalletVerifyAccountViewControllerSection.setting.rawValue {
            label.text = "General Information"
        } else {
            label.text = ""
        }
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == WalletVerifyAccountViewControllerSection.setting.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.verifyAccount, for: indexPath as IndexPath) as? VerifyAccountTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(section: self.viewModel.verifySection[indexPath.row])
            return cell ?? VerifyAccountTableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.notice, for: indexPath as IndexPath) as? NoticeTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? NoticeTableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == WalletVerifyAccountViewControllerSection.setting.rawValue {
            self.viewModel.openSettingSection(section: self.viewModel.verifySection[indexPath.row])
        }
    }
}
