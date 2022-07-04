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
//  MyQRCode.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 23/5/2565 BE.
//

import UIKit
import Core

class MyQRCode: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var castcleIdtitleLabel: UILabel!
    @IBOutlet private var castcleIdLabel: UILabel!
    @IBOutlet private var castcleImage: UIImageView!
    @IBOutlet private var qrCodeImage: UIImageView!
    @IBOutlet private var qrCodeView: UIView!

    private var qrCode: UIImage = UIImage()
    private var castcleId: String = ""

    required init(castcleId: String, qrCodeImage: UIImage) {
        self.castcleId = castcleId
        self.qrCode = qrCodeImage
        super.init(frame: CGRect(x: 0, y: 0, width: 414, height: 264))
        self.commonInit()
        self.layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
        self.layoutIfNeeded()
    }

    private func commonInit() {
        ConfigBundle.wallet.loadNibNamed(WalletNibVars.View.myQRCode, owner: self)
        addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.qrCodeView.backgroundColor = UIColor.Asset.white
        self.titleLabel.font = UIFont.asset(.medium, fontSize: .head4)
        self.titleLabel.textColor = UIColor.Asset.white
        self.castcleIdtitleLabel.font = UIFont.asset(.medium, fontSize: .head4)
        self.castcleIdtitleLabel.textColor = UIColor.Asset.white
        self.castcleIdLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.castcleIdLabel.textColor = UIColor.Asset.lightBlue
        self.castcleImage.image = UIImage.init(icon: .castcle(.logo), size: CGSize(width: 30, height: 30), textColor: UIColor.Asset.white)
        self.qrCodeImage.image = self.qrCode
        self.castcleIdLabel.text = self.castcleId
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
