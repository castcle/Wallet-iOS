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
//  MemoTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 31/5/2565 BE.
//

import UIKit
import Core

class MemoTableViewCell: UITableViewCell {

    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var noticLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var memoView: UIView!

    private let memo: String = "1234567890"

    override func awakeFromNib() {
        super.awakeFromNib()
        self.memoTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.memoTitleLabel.textColor = UIColor.Asset.white
        self.memoLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.memoLabel.textColor = UIColor.Asset.white
        self.noticLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.noticLabel.textColor = UIColor.Asset.denger
        self.copyButton.setImage(UIImage.init(icon: .castcle(.copy), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.memoView.custom(color: UIColor.Asset.darkGray, cornerRadius: 5)
        self.memoLabel.text = self.memo
        if let myQrCodeImage = Utility.generateQRCode(from: self.memo) {
            self.qrCodeImage.image = myQrCodeImage
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = self.memo
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
