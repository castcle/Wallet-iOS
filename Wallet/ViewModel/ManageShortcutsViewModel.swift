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
//  ManageShortcutsViewModel.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 8/7/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public final class ManageShortcutsViewModel {

    private var walletRepository: WalletRepository = WalletRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var accounts: [Shortcut] = []
    var shortcuts: [Shortcut] = []
    var page: PageRealm = PageRealm()
    var walletRequest: WalletRequest = WalletRequest()
    var loadState: LoadState = .loading
    var state: State = .none
    private var deleteShortcut: Shortcut = Shortcut()

    public init(page: PageRealm = PageRealm()) {
        self.tokenHelper.delegate = self
        self.page = page
    }

    func getWalletShortcuts() {
        self.state = .getWalletShortcuts
        self.loadState = .loading
        self.walletRepository.getWalletShortcuts(accountId: UserManager.shared.accountId) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.accounts = (json[JsonKey.accounts.rawValue].arrayValue).map { Shortcut(json: $0) }
                    self.shortcuts = (json[JsonKey.shortcuts.rawValue].arrayValue).map { Shortcut(json: $0) }
                    self.didGetWalletShortcutsFinish?()
                    self.loadState = .loaded
                } catch {
                    self.loadState = .loaded
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.loadState = .loaded
                }
            }
        }
    }

    func sortShortcuts() {
        self.state = .sortWalletShortcuts
        self.loadState = .loading
        var payload: [[String: Any]] = []
        for index in 0..<self.shortcuts.count {
            payload.append([
                JsonKey.id.rawValue: self.shortcuts[index].id,
                JsonKey.order.rawValue: (index + 1)
            ])
        }
        self.walletRequest.payloadSort = payload
        self.walletRepository.sortShortcuts(accountId: UserManager.shared.accountId, walletRequest: self.walletRequest) { (success, _, isRefreshToken) in
            if success {
                self.didSortShortcutsFinish?()
                self.loadState = .loaded
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.loadState = .loaded
                }
            }
        }
    }

    func deleteShortcut(deleteShortcut: Shortcut) {
        self.deleteShortcut = deleteShortcut
        self.state = .deleteWalletShortcut
        self.loadState = .loading
        self.walletRepository.deleteShortcut(accountId: UserManager.shared.accountId, shortcutId: self.deleteShortcut.id) { (success, _, isRefreshToken) in
            if success {
                self.didDeleteShortcutsFinish?()
                self.loadState = .loaded
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.loadState = .loaded
                }
            }
        }
    }

    var didGetWalletShortcutsFinish: (() -> Void)?
    var didSortShortcutsFinish: (() -> Void)?
    var didDeleteShortcutsFinish: (() -> Void)?
}

extension ManageShortcutsViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getWalletShortcuts {
            self.getWalletShortcuts()
        } else if self.state == .sortWalletShortcuts {
            self.sortShortcuts()
        } else if self.state == .deleteWalletShortcut {
            self.deleteShortcut(deleteShortcut: self.deleteShortcut)
        }
    }
}
