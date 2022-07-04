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
import Defaults

public enum ResendType {
    case all
    case castcle
    case other
}

protocol ResendViewControllerDelegate: AnyObject {
    func didSelect(_ resendViewController: ResendViewController, name: String)
}

class ResendViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchImage: UIImageView!

    public var delegate: ResendViewControllerDelegate?
    var resendType: ResendType = .all
    var isEmpty: Bool = false
    var isSearchCastcle: Bool = false
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
        self.searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.searchImage.image = UIImage.init(icon: .castcle(.search), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white)
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
        return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        self.isSearchCastcle = searchText.hasPrefix("@")
        self.isEmpty = !searchText.isEmpty
        self.tableView.reloadData()
    }

    @IBAction func backAction(_ sender: Any) {
        if self.resendType == .castcle || self.resendType == .other {
            self.resendType = .all
            self.tableView.reloadData()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func scanAction(_ sender: Any) {
        // MARK: - Add action
    }
}

extension ResendViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isEmpty {
            return 1
        } else {
            return ResendViewControllerSection.allCases.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isEmpty {
            return 1
        } else if self.resendType == .all {
            return 4
        } else {
            if section == ResendViewControllerSection.castcle.rawValue {
                return (self.resendType == .castcle ? 4 : 0)
            } else {
                return (self.resendType == .other ? 4 : 0)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isEmpty {
            return 0
        } else if self.resendType == .all {
            return 50
        } else {
            if section == ResendViewControllerSection.castcle.rawValue {
                return self.resendType == .castcle ? 50 : 0
            } else {
                return self.resendType == .other ? 50 : 0
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.isEmpty {
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
        if self.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.emptyData, for: indexPath as IndexPath) as? EmptyDataTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(isCastcle: self.isSearchCastcle)
            return cell ?? EmptyDataTableViewCell()
        } else if self.resendType == .all && indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.viewMore, for: indexPath as IndexPath) as? ViewMoreTableViewCell
            cell?.backgroundColor = UIColor.clear
            return cell ?? ViewMoreTableViewCell()
        } else {
            if indexPath.section == ResendViewControllerSection.castcle.rawValue {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.resendUser, for: indexPath as IndexPath) as? ResendUserTableViewCell
                cell?.backgroundColor = UIColor.clear
                cell?.configCell(name: "@simple_user\(indexPath.row + 1)")
                return cell ?? ResendUserTableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: WalletNibVars.TableViewCell.resendOther, for: indexPath as IndexPath) as? ResendOtherTableViewCell
                cell?.backgroundColor = UIColor.clear
                cell?.configCell(name: "Other User \(indexPath.row + 1)", address: "121231212\(indexPath.row + 1)")
                return cell ?? ResendOtherTableViewCell()
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.resendType == .all && indexPath.row == 3 {
            if indexPath.section == ResendViewControllerSection.castcle.rawValue {
                self.resendType = .castcle
            } else {
                self.resendType = .other
            }
            self.tableView.reloadData()
        } else if !self.isEmpty {
            if indexPath.section == ResendViewControllerSection.castcle.rawValue {
                self.delegate?.didSelect(self, name: "@simple_user\(indexPath.row + 1)")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.delegate?.didSelect(self, name: "121231212\(indexPath.row + 1)")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
