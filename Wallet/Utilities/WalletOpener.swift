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
//  WalletOpener.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 17/5/2565 BE.
//

import UIKit
import Core

public enum WalletScene {
    case wallet
    case selectPage(SelectPageViewModel)
    case scanQrCode(ScanQrCodeViewModel)
    case myQrCode(QrCodeType)
    case castcleQrCode(QrCodeType)
    case otherChain
    case selectNetwork
    case sendWallet(SendWalletViewModel)
    case sendReview(SendReviewViewModel)
    case sendAuth(SendReviewViewModel)
    case sendSuccess(SendSuccessViewModel)
    case verifyAccount
    case resend(RecentViewModel)
    case manageShortcuts(ManageShortcutsViewModel)
    case createShortcut(CreateShortcutViewModel)
}

public struct WalletOpener {
    public static func open(_ walletScene: WalletScene) -> UIViewController {
        switch walletScene {
        case .wallet:
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.wallet)
            return viewController
        case .selectPage(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.selectPage) as? SelectPageViewController
            viewController?.viewModel = viewModel
            return viewController ?? SelectPageViewController()
        case .scanQrCode(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.scanQrCode) as? ScanQrCodeViewController
            viewController?.viewModel = viewModel
            return viewController ?? ScanQrCodeViewController()
        case .myQrCode(let qrCodeType):
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.myQrCode) as? MyQrCodeViewController
            viewController?.qrCodeType = qrCodeType
            return viewController ?? MyQrCodeViewController()
        case .castcleQrCode(let qrCodeType):
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.castcleQrCode) as? CastcleQrCodeViewController
            viewController?.qrCodeType = qrCodeType
            return viewController ?? CastcleQrCodeViewController()
        case .otherChain:
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.otherChain)
            return viewController
        case .selectNetwork:
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.selectNetwork)
            return viewController
        case .sendWallet(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.sendWallet) as? SendWalletViewController
            viewController?.viewModel = viewModel
            return viewController ?? SendWalletViewController()
        case .sendReview(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.sendReview) as? SendReviewViewController
            viewController?.viewModel = viewModel
            return viewController ?? SendReviewViewController()
        case .sendAuth(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.sendAuth) as? SendAuthViewController
            viewController?.viewModel = viewModel
            return viewController ?? SendAuthViewController()
        case .sendSuccess(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.sendSuccess) as? SendSuccessViewController
            viewController?.viewModel = viewModel
            return viewController ?? SendSuccessViewController()
        case .verifyAccount:
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.verifyAccount)
            return viewController
        case .resend(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.resend) as? ResendViewController
            viewController?.viewModel = viewModel
            return viewController ?? ResendViewController()
        case .manageShortcuts(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.manageShortcuts) as? ManageShortcutsViewController
            viewController?.viewModel = viewModel
            return viewController ?? ManageShortcutsViewController()
        case .createShortcut(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.createShortcut) as? CreateShortcutViewController
            viewController?.viewModel = viewModel
            return viewController ?? CreateShortcutViewController()
        }
    }
}
