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
//  CastcleQrCodeTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 30/5/2565 BE.
//

import UIKit
import Core
import JGProgressHUD
import SwiftColor

class CastcleQrCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var qrCodeCastcleImage: UIImageView!
    @IBOutlet weak var shareQrCodeCastcleView: UIView!
    @IBOutlet weak var saveQrCodeCastcleView: UIView!
    @IBOutlet weak var shareQrCodeCastcleLabel: UILabel!
    @IBOutlet weak var saveQrCodeCastcleLabel: UILabel!
    @IBOutlet weak var shareQrCodeCastcleIcon: UIImageView!
    @IBOutlet weak var saveQrCodeCastcleIcon: UIImageView!
    @IBOutlet weak var castcleIdTitleLabel: UILabel!
    @IBOutlet weak var castcleIdLabel: UILabel!
    @IBOutlet weak var copyCastcleIdButton: UIButton!
    @IBOutlet weak var castcleIdView: UIView!

    private let hud = JGProgressHUD()
    private var myQrCode: UIImage?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.shareQrCodeCastcleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.shareQrCodeCastcleLabel.textColor = UIColor.Asset.white
        self.saveQrCodeCastcleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.saveQrCodeCastcleLabel.textColor = UIColor.Asset.white
        self.shareQrCodeCastcleView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 5)
        self.saveQrCodeCastcleView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 5)
        self.shareQrCodeCastcleIcon.image = UIImage.init(icon: .castcle(.share), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.saveQrCodeCastcleIcon.image = UIImage.init(icon: .castcle(.save), size: CGSize(width: 30, height: 30), textColor: UIColor.Asset.white)
        self.castcleIdTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.castcleIdTitleLabel.textColor = UIColor.Asset.white
        self.castcleIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.castcleIdLabel.textColor = UIColor.Asset.white
        self.copyCastcleIdButton.setImage(UIImage.init(icon: .castcle(.copy), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.castcleIdView.custom(color: UIColor.Asset.cellBackground, cornerRadius: 5)
        self.castcleIdLabel.text = UserManager.shared.castcleId
        self.qrCodeCastcleImage.image = UIColor.Asset.white.toImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(qrCodeImage: UIImage?) {
        self.myQrCode = qrCodeImage
        if let myQrCodeImage = self.myQrCode {
            self.qrCodeCastcleImage.image = myQrCodeImage
        }
    }

    @IBAction func copyCastcleIdAction(_ sender: Any) {
        UIPasteboard.general.string = UserManager.shared.castcleId
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    @IBAction func shareQrCodeCastcleAction(_ sender: Any) {
        if let myQrCodeImage = self.myQrCode {
            let myQRCode: MyQRCode = MyQRCode(castcleId: UserManager.shared.castcleId, qrCodeImage: myQrCodeImage)
            let activityView = UIActivityViewController(activityItems: [myQRCode.asImage()], applicationActivities: [])
            Utility.currentViewController().present(activityView, animated: true)
        }
    }

    @IBAction func saveQrCodeCastcleAction(_ sender: Any) {
        if let myQrCodeImage = self.myQrCode {
            let myQRCode: MyQRCode = MyQRCode(castcleId: UserManager.shared.castcleId, qrCodeImage: myQrCodeImage)
            UIImageWriteToSavedPhotosAlbum(myQRCode.asImage(), self, nil, nil)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.show(in: (Utility.currentViewController().navigationController?.view)!)
            self.hud.dismiss(afterDelay: 1.5)
        }
    }
}
