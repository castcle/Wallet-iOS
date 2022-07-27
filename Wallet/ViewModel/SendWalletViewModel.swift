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
//  SendWalletViewModel.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 8/7/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public final class SendWalletViewModel {

    private var walletRepository: WalletRepository = WalletRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var page: Page = Page()
    var walletRequest: WalletRequest = WalletRequest()
    var myShortcut: [Shortcut] = []
    var wallet: Wallet = Wallet()
    private var state: State = .none

    public init(page: Page = Page(), chainId: String = "", userId: String = "", castcleId: String = "", wallet: Wallet) {
        self.tokenHelper.delegate = self
        self.page = page
        self.walletRequest.chainId = (castcleId.isEmpty ? "castcle" : chainId)
        self.walletRequest.address = userId
        self.walletRequest.castcleId = castcleId
        self.wallet = wallet
    }

    func getWalletShortcuts() {
        self.state = .getWalletShortcuts
        self.walletRepository.getWalletShortcuts(accountId: UserManager.shared.accountId) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let accounts = (json[JsonKey.accounts.rawValue].arrayValue).map { Shortcut(json: $0) }.filter { $0.userId != self.page.id }
                    let shortcuts = (json[JsonKey.shortcuts.rawValue].arrayValue).map { Shortcut(json: $0) }
                    self.myShortcut = []
                    self.myShortcut.append(contentsOf: accounts)
                    self.myShortcut.append(contentsOf: shortcuts)
                    self.didGetWalletShortcutsFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    func reviewSendToken() {
        self.state = .reviewSendToken
        self.walletRepository.reviewSendToken(userId: self.page.id, walletRequest: self.walletRequest) { (success, _, isRefreshToken) in
            if success {
                self.didReviewSendTokenFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    var didGetWalletShortcutsFinish: (() -> Void)?
    var didReviewSendTokenFinish: (() -> Void)?
    var didError: (() -> Void)?
}

extension SendWalletViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getWalletShortcuts {
            self.getWalletShortcuts()
        } else if self.state == .reviewSendToken {
            self.reviewSendToken()
        }
    }
}
