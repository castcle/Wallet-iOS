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
//  OtherChainViewController.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 31/5/2565 BE.
//

import UIKit
import Core
import XLPagerTabStrip

class OtherChainViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var pageIndex: Int = 0
    var pageTitle: String?

    enum OtherChainViewControllerSection: Int, CaseIterable {
        case qrCodeChain = 0
        case qrCodeMemo
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.otherChain, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.otherChain)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.memo, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.memo)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension OtherChainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OtherChainViewControllerSection.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case OtherChainViewControllerSection.qrCodeChain.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.otherChain, for: indexPath as IndexPath) as? OtherChainTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? OtherChainTableViewCell()
        case OtherChainViewControllerSection.qrCodeMemo.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.memo, for: indexPath as IndexPath) as? MemoTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? MemoTableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

extension OtherChainViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab \(pageIndex)")
    }
}
