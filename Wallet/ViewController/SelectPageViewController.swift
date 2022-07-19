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
//  SelectPageViewController.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 17/5/2565 BE.
//

import UIKit
import Core
import Networking
import Defaults
import PanModal

protocol SelectPageViewControllerDelegate: AnyObject {
    func didChoosePage(_ view: SelectPageViewController, page: Page)
}

class SelectPageViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var delegate: SelectPageViewControllerDelegate?
    var viewModel = SelectPageViewModel()
    var maxHeight = (UIScreen.main.bounds.height - 365)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.displayName, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.displayName)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension SelectPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.pages.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.displayName, for: indexPath as IndexPath) as? DisplayNameTableViewCell
        let page = self.viewModel.pages[indexPath.section]
        cell?.configCell(page: page, isDisplayOnly: true)
        cell?.backgroundColor = UIColor.Asset.cellBackground
        if page.castcleId == self.viewModel.selectPage.castcleId {
            cell?.iconImage.isHidden = false
        } else {
            cell?.iconImage.isHidden = true
        }
        return cell ?? DisplayNameTableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 5))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didChoosePage(self, page: self.viewModel.pages[indexPath.section])
        self.dismiss(animated: true)
    }
}

extension SelectPageViewController: PanModalPresentable {
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var panScrollable: UIScrollView? {
        return nil
    }

    public var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(self.maxHeight)
    }

    public var anchorModalToLongForm: Bool {
        return false
    }
}
