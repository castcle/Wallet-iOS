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
//  CreateShortcutTableViewCell.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 10/7/2565 BE.
//

import UIKit
import Core
import Networking
import Kingfisher
import JGProgressHUD

class CreateShortcutTableViewCell: UITableViewCell {

    @IBOutlet weak var idTitleLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var shortcutAvatarImage: UIImageView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var dataView: UIView!

    private var viewModel = CreateShortcutViewModel()
    private let hud = JGProgressHUD()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.idTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.idTitleLabel.textColor = UIColor.Asset.white
        self.nameTitleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.nameTitleLabel.textColor = UIColor.Asset.white
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.idTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.idTextField.textColor = UIColor.Asset.white
        self.idView.capsule(color: UIColor.Asset.cellBackground)
        self.nameView.capsule(color: UIColor.Asset.cellBackground)
        self.shortcutAvatarImage.circle(color: UIColor.Asset.white)
        self.scanButton.setImage(UIImage.init(icon: .castcle(.qrCode), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.confirmButton.activeButton(isActive: false, fontSize: .overline)
        self.dataView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(viewModel: CreateShortcutViewModel) {
        self.viewModel = viewModel
        if !self.viewModel.shortcut.id.isEmpty {
            self.viewModel.walletRequest.userId = self.viewModel.shortcut.userId
            self.viewModel.castcleId = self.viewModel.shortcut.castcleId
            let shortcutAvatar = URL(string: self.viewModel.shortcut.images.avatar.thumbnail)
            self.shortcutAvatarImage.kf.setImage(with: shortcutAvatar, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.updateUI()
        }
        self.viewModel.didCreateShortcutFinish = {
            self.hud.dismiss()
            Utility.currentViewController().navigationController?.popViewController(animated: true)
        }
        self.viewModel.didUpdateShortcutFinish = {
            self.hud.dismiss()
            Utility.currentViewController().navigationController?.popViewController(animated: true)
        }
    }

    private func updateUI() {
        self.displayNameLabel.text = "@\(self.viewModel.castcleId)"
        self.idTextField.text = "@\(self.viewModel.castcleId)"
        self.confirmButton.activeButton(isActive: true, fontSize: .overline)
        self.dataView.isHidden = false
    }

    @IBAction func resendAction(_ sender: Any) {
        let viewController = WalletOpener.open(.resend(RecentViewModel(page: self.viewModel.page))) as? ResendViewController
        viewController?.delegate = self
        Utility.currentViewController().navigationController?.pushViewController(viewController ?? ResendViewController(), animated: true)
    }

    @IBAction func scanSendToAction(_ sender: Any) {
        let viewController = WalletOpener.open(.scanQrCode(ScanQrCodeViewModel(scanType: .wallet))) as? ScanQrCodeViewController
        viewController?.delegate = self
        Utility.currentViewController().navigationController?.pushViewController(viewController ?? ScanQrCodeViewController(), animated: true)
    }

    @IBAction func confirmAction(_ sender: Any) {
        if !self.viewModel.shortcut.id.isEmpty && !self.viewModel.walletRequest.userId.isEmpty {
            self.hud.textLabel.text = "Updating"
            self.hud.show(in: Utility.currentViewController().view)
            self.viewModel.updateShortcut()
        } else if self.viewModel.shortcut.id.isEmpty && !self.viewModel.walletRequest.userId.isEmpty {
            self.hud.textLabel.text = "Creating"
            self.hud.show(in: Utility.currentViewController().view)
            self.viewModel.createShortcutCastcle()
        }
    }
}

extension CreateShortcutTableViewCell: ResendViewControllerDelegate {
    func didSelect(_ resendViewController: ResendViewController, walletsRecent: WalletsRecent) {
        self.viewModel.walletsRecent = walletsRecent
        self.viewModel.walletRequest.userId = walletsRecent.id
        self.viewModel.castcleId = walletsRecent.castcleId
        let shortcutAvatar = URL(string: walletsRecent.images.avatar.thumbnail)
        self.shortcutAvatarImage.kf.setImage(with: shortcutAvatar, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.updateUI()
    }

    func didScanWalletSuccess(_ resendViewController: ResendViewController, chainId: String, userId: String, castcleId: String) {
        self.viewModel.walletRequest.userId = userId
        self.viewModel.castcleId = castcleId
        self.shortcutAvatarImage.image = UIImage.Asset.userPlaceholder
        self.updateUI()
    }
}

extension CreateShortcutTableViewCell: ScanQrCodeViewControllerDelegate {
    func didScanWalletSuccess(_ scanQrCodeViewController: ScanQrCodeViewController, chainId: String, userId: String, castcleId: String) {
        self.viewModel.walletRequest.userId = userId
        self.viewModel.castcleId = castcleId
        self.displayNameLabel.text = "@\(castcleId)"
        self.idTextField.text = "@\(castcleId)"
        self.shortcutAvatarImage.image = UIImage.Asset.userPlaceholder
        self.confirmButton.activeButton(isActive: true, fontSize: .overline)
        self.dataView.isHidden = false
    }

    func didScanTextSuccess(_ scanQrCodeViewController: ScanQrCodeViewController, text: String) {
        // MARK: - Not use
    }
}
