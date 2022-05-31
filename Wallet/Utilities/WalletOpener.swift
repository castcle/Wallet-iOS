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
    case scanQrCode
    case myQrCode
    case castcleQrCode
    case otherChain
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
        case .scanQrCode:
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.scanQrCode)
            return viewController
        case .myQrCode:
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.myQrCode)
            return viewController
        case .castcleQrCode:
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.castcleQrCode)
            return viewController
        case .otherChain:
            let storyboard: UIStoryboard = UIStoryboard(name: WalletNibVars.Storyboard.wallet, bundle: ConfigBundle.wallet)
            let viewController = storyboard.instantiateViewController(withIdentifier: WalletNibVars.ViewController.otherChain)
            return viewController
        }
    }
}
