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
//  CreateShortcutViewModel.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 11/7/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public final class CreateShortcutViewModel {

    private var walletRepository: WalletRepository = WalletRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var page: Page = Page()
    var shortcut: Shortcut = Shortcut()
    var walletsRecent: WalletsRecent = WalletsRecent()
    var walletRequest: WalletRequest = WalletRequest()
    var castcleId: String = ""
    var state: State = .none

    public init(page: Page = Page(), shortcut: Shortcut = Shortcut()) {
        self.tokenHelper.delegate = self
        self.page = page
        self.shortcut = shortcut
    }

    func createShortcutCastcle() {
        self.state = .createWalletShortcut
        self.walletRepository.createShortcutCastcle(accountId: UserManager.shared.accountId, walletRequest: self.walletRequest) { (success, _, isRefreshToken) in
            if success {
                self.didCreateShortcutFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    func updateShortcut() {
        self.state = .updateWalletShortcut
        self.walletRepository.updateShortcut(accountId: UserManager.shared.accountId, shortcutId: self.shortcut.id, walletRequest: self.walletRequest) { (success, _, isRefreshToken) in
            if success {
                self.didUpdateShortcutFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    var didCreateShortcutFinish: (() -> Void)?
    var didUpdateShortcutFinish: (() -> Void)?
    var didError: (() -> Void)?
}

extension CreateShortcutViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .createWalletShortcut {
            self.createShortcutCastcle()
        } else if self.state == .updateWalletShortcut {
            self.updateShortcut()
        }
    }
}
