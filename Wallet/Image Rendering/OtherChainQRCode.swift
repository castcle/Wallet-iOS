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
//  OtherChainQRCode.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 31/5/2565 BE.
//

import UIKit
import Core

class OtherChainQRCode: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var castcleIdLabel: UILabel!
    @IBOutlet private var dateTimeLabel: UILabel!
    @IBOutlet private var addressTitleLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var memoTitleLabel: UILabel!
    @IBOutlet private var memoLabel: UILabel!
    @IBOutlet private var castcleImage: UIImageView!
    @IBOutlet private var qrCodeAddressImage: UIImageView!
    @IBOutlet private var qrCodeAddressView: UIView!
    @IBOutlet private var qrCodeMemoImage: UIImageView!
    @IBOutlet private var qrCodeMemoView: UIView!

    private var casecleId: String = ""
    private var address: String = ""
    private var memo: String = ""
    private var addressQrCode: UIImage = UIImage()
    private var memoQrCode: UIImage = UIImage()

    required init(casecleId: String, address: String, addressQrCode: UIImage, memo: String, memoQrCode: UIImage) {
        self.casecleId = casecleId
        self.address = address
        self.addressQrCode = addressQrCode
        self.memo = memo
        self.memoQrCode = memoQrCode
        super.init(frame: CGRect(x: 0, y: 0, width: 414, height: 480))
        self.commonInit()
        self.layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
        self.layoutIfNeeded()
    }

    private func commonInit() {
        ConfigBundle.wallet.loadNibNamed(WalletNibVars.View.otherChainQRCode, owner: self)
        addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.qrCodeAddressView.backgroundColor = UIColor.Asset.white
        self.qrCodeMemoView.backgroundColor = UIColor.Asset.white
        self.titleLabel.font = UIFont.asset(.medium, fontSize: .head4)
        self.titleLabel.textColor = UIColor.Asset.white
        self.castcleIdLabel.font = UIFont.asset(.medium, fontSize: .head4)
        self.castcleIdLabel.textColor = UIColor.Asset.white
        self.dateTimeLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.dateTimeLabel.textColor = UIColor.Asset.white
        self.addressTitleLabel.font = UIFont.asset(.medium, fontSize: .head4)
        self.addressTitleLabel.textColor = UIColor.Asset.white
        self.addressLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.addressLabel.textColor = UIColor.Asset.lightBlue
        self.memoTitleLabel.font = UIFont.asset(.medium, fontSize: .head4)
        self.memoTitleLabel.textColor = UIColor.Asset.white
        self.memoLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.memoLabel.textColor = UIColor.Asset.lightBlue
        self.castcleImage.image = UIImage.init(icon: .castcle(.logo), size: CGSize(width: 30, height: 30), textColor: UIColor.Asset.white)
        self.addressLabel.text = self.address
        self.qrCodeAddressImage.image = addressQrCode
        self.memoLabel.text = self.memo
        self.qrCodeMemoImage.image = memoQrCode
        self.castcleIdLabel.text = UserManager.shared.castcleId
        self.dateTimeLabel.text = "\(Date().dateToString()) \(Date().timeToString())"
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
