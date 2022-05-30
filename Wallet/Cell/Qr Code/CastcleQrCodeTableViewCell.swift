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

class CastcleQrCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var regenView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var regenLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var regenIcon: UIImageView!
    @IBOutlet weak var shareIcon: UIImageView!
    @IBOutlet weak var saveIcon: UIImageView!
    @IBOutlet weak var castcleIdTitleLabel: UILabel!
    @IBOutlet weak var castcleIdLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var castcleIdView: UIView!

    private let hud = JGProgressHUD()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.regenLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.regenLabel.textColor = UIColor.Asset.white
        self.shareLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.shareLabel.textColor = UIColor.Asset.white
        self.saveLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.saveLabel.textColor = UIColor.Asset.white
        self.regenView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 5)
        self.shareView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 5)
        self.saveView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 5)
        self.regenIcon.image = UIImage.init(icon: .castcle(.remind), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.shareIcon.image = UIImage.init(icon: .castcle(.remind), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.saveIcon.image = UIImage.init(icon: .castcle(.remind), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.castcleIdTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.castcleIdTitleLabel.textColor = UIColor.Asset.white
        self.castcleIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.castcleIdLabel.textColor = UIColor.Asset.white
        self.copyButton.setImage(UIImage.init(icon: .castcle(.coin), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.castcleIdView.custom(color: UIColor.Asset.darkGray, cornerRadius: 5)
        self.castcleIdLabel.text = UserManager.shared.castcleId
        if let myQrCodeImage = Utility.generateQRCode(from: UserManager.shared.rawCastcleId) {
            self.qrCodeImage.image = myQrCodeImage
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = UserManager.shared.rawCastcleId
    }

    @IBAction func regenAction(_ sender: Any) {
        // TODO: - Call function regenerate
    }

    @IBAction func shareAction(_ sender: Any) {
        if let myQrCodeImage = Utility.generateQRCode(from: UserManager.shared.rawCastcleId) {
            let myQRCode: MyQRCode = MyQRCode(frame: CGRect(x: 0, y: 0, width: 414, height: 264))
            myQRCode.castcleIdLabel.text = UserManager.shared.castcleId
            myQRCode.qrCodeImage.image = myQrCodeImage
            let activityView = UIActivityViewController(activityItems: [myQRCode.asImage()], applicationActivities: [])
            Utility.currentViewController().present(activityView, animated: true)
        }
    }

    @IBAction func saveAction(_ sender: Any) {
        if let myQrCodeImage = Utility.generateQRCode(from: UserManager.shared.rawCastcleId) {
            let myQRCode: MyQRCode = MyQRCode(frame: CGRect(x: 0, y: 0, width: 414, height: 264))
            myQRCode.castcleIdLabel.text = UserManager.shared.castcleId
            myQRCode.qrCodeImage.image = myQrCodeImage
            UIImageWriteToSavedPhotosAlbum(myQRCode.asImage(), self, nil, nil)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.show(in: Utility.currentViewController().view)
            self.hud.dismiss(afterDelay: 1.5)
        }
    }
}