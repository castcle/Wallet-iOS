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
//  SendVerifyTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 1/7/2565 BE.
//

import UIKit
import Core

protocol SendVerifyTableViewCellDelegate: AnyObject {
    func didValueChange(_ sendVerifyTableViewCell: SendVerifyTableViewCell, verifyEmail: String, verifySms: String)
}

class SendVerifyTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var emailVerifyLabel: UILabel!
    @IBOutlet weak var emailNoteLabel: UILabel!
    @IBOutlet weak var emailCountdownLabel: UILabel!
    @IBOutlet weak var smsVerifyLabel: UILabel!
    @IBOutlet weak var smsNoteLabel: UILabel!
    @IBOutlet weak var smsCountdownLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var smsView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var smsTextField: UITextField!
    @IBOutlet weak var resendEmailButton: UIButton!
    @IBOutlet weak var resendSmsButton: UIButton!

    public var delegate: SendVerifyTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.emailVerifyLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.emailVerifyLabel.textColor = UIColor.Asset.white
        self.smsVerifyLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.smsVerifyLabel.textColor = UIColor.Asset.white
        self.emailNoteLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.emailNoteLabel.textColor = UIColor.Asset.lightBlue
        self.smsNoteLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.smsNoteLabel.textColor = UIColor.Asset.lightBlue
        self.emailCountdownLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.emailCountdownLabel.textColor = UIColor.Asset.lightBlue
        self.smsCountdownLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.smsCountdownLabel.textColor = UIColor.Asset.lightBlue
        self.emailTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.emailTextField.textColor = UIColor.Asset.white
        self.smsTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.smsTextField.textColor = UIColor.Asset.white
        self.emailView.capsule(color: UIColor.Asset.darkGray)
        self.smsView.capsule(color: UIColor.Asset.darkGray)
        self.resendEmailButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.resendEmailButton.setTitleColor(UIColor.Asset.darkGray, for: .normal)
        self.resendSmsButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.resendSmsButton.setTitleColor(UIColor.Asset.darkGray, for: .normal)
        self.emailTextField.delegate = self
        self.emailTextField.tag = 0
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.smsTextField.delegate = self
        self.smsTextField.tag = 1
        self.smsTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.smsTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        self.delegate?.didValueChange(self, verifyEmail: self.emailTextField.text ?? "", verifySms: self.smsTextField.text ?? "")
    }

    @IBAction func resendEmailAction(_ sender: Any) {
        // MARK: - Add action
    }

    @IBAction func resendSmsAction(_ sender: Any) {
        // MARK: - Add action
    }
}
