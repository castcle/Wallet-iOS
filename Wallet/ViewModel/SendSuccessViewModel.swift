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
//  SendSuccessViewModel.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 24/9/2565 BE.
//

import Core
import Networking
import SwiftyJSON

struct SendSuccess {
    let title: String
    let value: String
}

public final class SendSuccessViewModel {

    private var walletRepository: WalletRepository = WalletRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var page: PageRealm = PageRealm()
    var myShortcut: [Shortcut] = []
    var walletRequest: WalletRequest = WalletRequest()
    private var state: State = .none
    var sendSuccess: [SendSuccess] = []
    var isShortcut: Bool = true

    public init(walletRequest: WalletRequest = WalletRequest(), page: PageRealm = PageRealm(), shortcuts: [Shortcut] = []) {
        self.tokenHelper.delegate = self
        self.walletRequest = walletRequest
        self.page = page
        self.myShortcut = shortcuts
        self.mappingUi()
        self.checkMyShortcut()
    }

    private func mappingUi() {
        self.sendSuccess.append(SendSuccess(title: "Review send", value: "\(self.walletRequest.amount) CAST"))
        self.sendSuccess.append(SendSuccess(title: "Date", value: Date().dateToString()))
        self.sendSuccess.append(SendSuccess(title: "From", value: self.page.castcleId))
        self.sendSuccess.append(SendSuccess(title: "To Castcle ID", value: self.walletRequest.castcleId))
        self.sendSuccess.append(SendSuccess(title: "Coin", value: "CAST"))
        self.sendSuccess.append(SendSuccess(title: "Amount", value: "\(self.walletRequest.amount) CAST"))
        self.sendSuccess.append(SendSuccess(title: "Network fee", value: "0 CAST"))
    }

    private func checkMyShortcut() {
        let shortcut = self.myShortcut.filter { $0.castcleId == self.walletRequest.castcleId }.first
        if shortcut != nil {
            self.isShortcut = true
        } else {
            self.isShortcut = false
        }
    }

    func createShortcutCastcle() {
        self.state = .createWalletShortcut
        self.walletRepository.createShortcutCastcle(accountId: UserManager.shared.accountId, walletRequest: self.walletRequest) { (success, _, isRefreshToken) in
            if success {
                self.isShortcut = true
                self.didManageShortcutsFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    var didManageShortcutsFinish: (() -> Void)?
    var didError: (() -> Void)?
}

extension SendSuccessViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .createWalletShortcut {
            self.createShortcutCastcle()
        }
    }
}
