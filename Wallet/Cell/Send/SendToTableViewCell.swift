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
//  SendToTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 30/6/2565 BE.
//

import UIKit
import Core

protocol SendToTableViewCellDelegate: AnyObject {
    func didValueChange(_ sendToTableViewCell: SendToTableViewCell, sendTo: String, memo: String, amount: String, note: String)
}

class SendToTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var sendToTitle: UILabel!
    @IBOutlet weak var memoTitle: UILabel!
    @IBOutlet weak var amountTitle: UILabel!
    @IBOutlet weak var currentBalanceTitle: UILabel!
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var sendToView: UIView!
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var sendToTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var scanSendToButton: UIButton!
    @IBOutlet weak var scanMemoButton: UIButton!
    @IBOutlet weak var maxButton: UIButton!

    public var delegate: SendToTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.sendToTitle.font = UIFont.asset(.bold, fontSize: .body)
        self.sendToTitle.textColor = UIColor.Asset.white
        self.memoTitle.font = UIFont.asset(.bold, fontSize: .body)
        self.memoTitle.textColor = UIColor.Asset.white
        self.amountTitle.font = UIFont.asset(.bold, fontSize: .body)
        self.amountTitle.textColor = UIColor.Asset.white
        self.currentBalanceTitle.font = UIFont.asset(.regular, fontSize: .small)
        self.currentBalanceTitle.textColor = UIColor.Asset.lightBlue
        self.noteTitle.font = UIFont.asset(.bold, fontSize: .body)
        self.noteTitle.textColor = UIColor.Asset.white
        self.sendToTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.sendToTextField.textColor = UIColor.Asset.white
        self.memoTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.memoTextField.textColor = UIColor.Asset.white
        self.amountTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.amountTextField.textColor = UIColor.Asset.white
        self.noteTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.noteTextField.textColor = UIColor.Asset.white
        self.sendToView.capsule(color: UIColor.Asset.darkGray)
        self.memoView.capsule(color: UIColor.Asset.darkGray)
        self.amountView.capsule(color: UIColor.Asset.darkGray)
        self.noteView.capsule(color: UIColor.Asset.darkGray)
        self.maxButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.maxButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.scanSendToButton.setImage(UIImage.init(icon: .castcle(.qrCode), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.scanMemoButton.setImage(UIImage.init(icon: .castcle(.qrCode), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.sendToTextField.delegate = self
        self.sendToTextField.tag = 0
        self.sendToTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.memoTextField.delegate = self
        self.memoTextField.tag = 1
        self.memoTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.amountTextField.delegate = self
        self.amountTextField.tag = 2
        self.amountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.noteTextField.delegate = self
        self.noteTextField.tag = 3
        self.noteTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.memoTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            self.amountTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
            self.noteTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        self.delegate?.didValueChange(self, sendTo: self.sendToTextField.text ?? "", memo: self.memoTextField.text ?? "", amount: self.amountTextField.text ?? "", note: self.noteTextField.text ?? "")
    }

    @IBAction func scanSendToAction(_ sender: Any) {
        // MARK: - Add action
    }

    @IBAction func scanMemoAction(_ sender: Any) {
        // MARK: - Add action
    }

    @IBAction func maxAction(_ sender: Any) {
        self.amountTextField.text = "10"
    }
}
