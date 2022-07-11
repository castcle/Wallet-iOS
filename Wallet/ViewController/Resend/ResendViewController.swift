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
//  ResendViewController.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 1/7/2565 BE.
//

import UIKit
import Core
import Networking
import Defaults
import JGProgressHUD

protocol ResendViewControllerDelegate: AnyObject {
    func didSelect(_ resendViewController: ResendViewController, walletsRecent: WalletsRecent)
}

class ResendViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchImage: UIImageView!

    private let hud = JGProgressHUD()
    var viewModel = RecentViewModel()
    public var delegate: ResendViewControllerDelegate?
    enum ResendViewControllerSection: Int, CaseIterable {
        case castcle = 0
        case other
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.configureTableView()
        self.backButton.setImage(UIImage.init(icon: .castcle(.back), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.scanButton.setImage(UIImage.init(icon: .castcle(.qrCode), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.searchView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10)
        self.searchTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.searchTextField.textColor = UIColor.Asset.white
        self.searchTextField.delegate = self
        self.searchImage.image = UIImage.init(icon: .castcle(.search), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white)
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: self.view)
        self.viewModel.getWalletRecent()
        self.viewModel.didGetWalletRecentFinish = {
            self.hud.dismiss()
        }
        self.viewModel.didGetWalletSearchFinish = {
            self.hud.dismiss()
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        Defaults[.screenId] = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.resendUser, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.resendUser)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.resendOther, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.resendOther)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.viewMore, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.viewMore)
        self.tableView.register(UINib(nibName: WalletNibVars.TableViewCell.emptyData, bundle: ConfigBundle.wallet), forCellReuseIdentifier: WalletNibVars.TableViewCell.emptyData)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let searchText = textField.text ?? ""
        if !searchText.isEmpty {
            self.viewModel.isSearch = true
            self.viewModel.isSearchCastcle = searchText.hasPrefix("@")
            self.viewModel.walletRequest.keyword = searchText
            self.hud.textLabel.text = "Searching"
            self.hud.show(in: self.view)
            self.viewModel.walletSearch()
        } else {
            self.viewModel.isSearch = false
            self.viewModel.walletRequest.keyword = ""
            self.tableView.reloadData()
        }
        return true
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func scanAction(_ sender: Any) {
        // MARK: - Add action
    }
}

extension ResendViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.isSearch {
            return 1
        } else {
            return ResendViewControllerSection.allCases.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.isSearch {
            return (self.viewModel.searchCastcle.count > 0 ? self.viewModel.searchCastcle.count : 1)
        } else {
            if section == ResendViewControllerSection.castcle.rawValue {
                return self.getRowRecent(isCastcle: true)
            } else {
                return self.getRowRecent(isCastcle: false)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.viewModel.isSearch {
            return 0
        } else {
            if section == ResendViewControllerSection.castcle.rawValue {
                return self.viewModel.castcle.count > 0 ? 50 : 0
            } else {
                return self.viewModel.other.count > 0 ? 50 : 0
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.viewModel.isSearch {
            return UIView()
        } else {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.backgroundColor = UIColor.Asset.darkGraphiteBlue
            let label = UILabel()
            label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
            label.font = UIFont.asset(.bold, fontSize: .body)
            label.textColor = UIColor.Asset.white
            if section == ResendViewControllerSection.castcle.rawValue {
                label.text = "Recent Castcle ID"
            } else {
                label.text = "Recent wallet address"
            }
            headerView.addSubview(label)
            return headerView
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.isSearch {
            if self.viewModel.searchCastcle.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.emptyData, for: indexPath as IndexPath) as? EmptyDataTableViewCell
                cell?.backgroundColor = UIColor.clear
                cell?.configCell(isCastcle: self.viewModel.isSearchCastcle)
                return cell ?? EmptyDataTableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.resendUser, for: indexPath as IndexPath) as? ResendUserTableViewCell
                cell?.backgroundColor = UIColor.clear
                cell?.configCell(walletsRecent: self.viewModel.searchCastcle[indexPath.row])
                return cell ?? ResendUserTableViewCell()
            }
        } else {
            if indexPath.section == ResendViewControllerSection.castcle.rawValue {
                return self.getRecentCell(isCastcle: true, tableView: tableView, didSelectRowAt: indexPath)
            } else {
                return self.getRecentCell(isCastcle: false, tableView: tableView, didSelectRowAt: indexPath)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.isSearch && !self.viewModel.searchCastcle.isEmpty {
            self.delegate?.didSelect(self, walletsRecent: self.viewModel.searchCastcle[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        } else {
            if indexPath.section == ResendViewControllerSection.castcle.rawValue {
                if !self.viewModel.isCastcleRecentExpand && indexPath.row == 3 {
                    self.viewModel.isCastcleRecentExpand = true
                    self.tableView.reloadData()
                } else {
                    self.delegate?.didSelect(self, walletsRecent: self.viewModel.castcle[indexPath.row])
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                if !self.viewModel.isOtherRecentExpand && indexPath.row == 3 {
                    self.viewModel.isOtherRecentExpand = true
                    self.tableView.reloadData()
                } else {
                    self.delegate?.didSelect(self, walletsRecent: self.viewModel.other[indexPath.row])
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    private func getRowRecent(isCastcle: Bool) -> Int {
        if isCastcle {
            if !self.viewModel.isCastcleRecentExpand && (self.viewModel.castcle.count > 3) {
                return 4
            } else {
                return self.viewModel.castcle.count
            }
        } else {
            if !self.viewModel.isOtherRecentExpand && (self.viewModel.other.count > 3) {
                return 4
            } else {
                return self.viewModel.other.count
            }
        }
    }

    private func getRecentCell(isCastcle: Bool, tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> UITableViewCell {
        if isCastcle {
            if !self.viewModel.isCastcleRecentExpand && indexPath
                .row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.viewMore, for: indexPath as IndexPath) as? ViewMoreTableViewCell
                cell?.backgroundColor = UIColor.clear
                return cell ?? ViewMoreTableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.resendUser, for: indexPath as IndexPath) as? ResendUserTableViewCell
                cell?.backgroundColor = UIColor.clear
                cell?.configCell(walletsRecent: self.viewModel.castcle[indexPath.row])
                return cell ?? ResendUserTableViewCell()
            }
        } else {
            if !self.viewModel.isOtherRecentExpand && indexPath
                .row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.viewMore, for: indexPath as IndexPath) as? ViewMoreTableViewCell
                cell?.backgroundColor = UIColor.clear
                return cell ?? ViewMoreTableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.resendOther, for: indexPath as IndexPath) as? ResendOtherTableViewCell
                cell?.backgroundColor = UIColor.clear
                cell?.configCell(walletsRecent: self.viewModel.other[indexPath.row])
                return cell ?? ResendOtherTableViewCell()
            }
        }
    }
}
