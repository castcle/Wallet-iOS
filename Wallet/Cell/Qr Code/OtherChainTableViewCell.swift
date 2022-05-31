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
//  OtherChainTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 31/5/2565 BE.
//

import UIKit
import Core
import JGProgressHUD

class OtherChainTableViewCell: UITableViewCell {

    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var shareIcon: UIImageView!
    @IBOutlet weak var saveIcon: UIImageView!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var networkTitleLabel: UILabel!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var changeNetworkButton: UIButton!
    @IBOutlet weak var addressView: UIView!

    private let hud = JGProgressHUD()
    private let address: String = "ajshkjsdgUUSUjsdfjajsgaSdasdf8hdfghaer0asie9rhgwerhgaefbkb8fu4t8IAihsdbviohisdgaknlOAUSifisvnkcvoo0"
    private let memo: String = "1234567890"

    override func awakeFromNib() {
        super.awakeFromNib()
        self.shareLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.shareLabel.textColor = UIColor.Asset.white
        self.saveLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.saveLabel.textColor = UIColor.Asset.white
        self.shareView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 5)
        self.saveView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 5)
        self.shareIcon.image = UIImage.init(icon: .castcle(.remind), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.saveIcon.image = UIImage.init(icon: .castcle(.remind), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.networkTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.networkTitleLabel.textColor = UIColor.Asset.white
        self.networkLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.networkLabel.textColor = UIColor.Asset.lightBlue
        self.addressTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.addressTitleLabel.textColor = UIColor.Asset.white
        self.addressLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.addressLabel.textColor = UIColor.Asset.white
        self.copyButton.setImage(UIImage.init(icon: .castcle(.coin), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.changeNetworkButton.setImage(UIImage.init(icon: .castcle(.remind), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.addressView.custom(color: UIColor.Asset.darkGray, cornerRadius: 5)
        self.addressLabel.text = self.address
        if let myQrCodeImage = Utility.generateQRCode(from: self.address) {
            self.qrCodeImage.image = myQrCodeImage
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func changeNetworkAction(_ sender: Any) {
    }

    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = self.address
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    @IBAction func shareAction(_ sender: Any) {
        if let addressQrCodeImage = Utility.generateQRCode(from: self.address), let memoQrCodeImage = Utility.generateQRCode(from: self.memo) {
            let otherChainQRCode: OtherChainQRCode = OtherChainQRCode(casecleId: UserManager.shared.castcleId, address: self.address, addressQrCode: addressQrCodeImage, memo: self.memo, memoQrCode: memoQrCodeImage)
            let activityView = UIActivityViewController(activityItems: [otherChainQRCode.asImage()], applicationActivities: [])
            Utility.currentViewController().present(activityView, animated: true)
        }
    }

    @IBAction func saveAction(_ sender: Any) {
        if let addressQrCodeImage = Utility.generateQRCode(from: self.address), let memoQrCodeImage = Utility.generateQRCode(from: self.memo) {
            let otherChainQRCode: OtherChainQRCode = OtherChainQRCode(casecleId: UserManager.shared.castcleId, address: self.address, addressQrCode: addressQrCodeImage, memo: self.memo, memoQrCode: memoQrCodeImage)
            UIImageWriteToSavedPhotosAlbum(otherChainQRCode.asImage(), self, nil, nil)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.show(in: Utility.currentViewController().view)
            self.hud.dismiss(afterDelay: 1.5)
        }
    }
}
