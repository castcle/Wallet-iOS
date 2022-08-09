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
//  WalletViewModel.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 17/5/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public final class WalletViewModel {
    private var walletRepository: WalletRepository = WalletRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var page: PageRealm = PageRealm()
    var walletRequest: WalletRequest = WalletRequest()
    var wallet: Wallet = Wallet()
    var history: [WalletHistory] = []
    private var state: State = .none

    public init() {
        self.page = PageRealm().initCustom(id: UserManager.shared.id, displayName: UserManager.shared.displayName, castcleId: UserManager.shared.castcleId, avatar: UserManager.shared.avatar, cover: UserManager.shared.cover, overview: UserManager.shared.overview, official: UserManager.shared.official)
        self.tokenHelper.delegate = self
    }

    func walletLookup() {
        self.state = .walletLookup
        self.walletRepository.walletLookup(userId: self.page.id) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.wallet = Wallet(json: json)
                    self.didGetWalletBalanceFinish?()
                } catch {
                    self.didError?()
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    func getWalletHistory() {
        self.state = .getWalletHistory
        self.walletRepository.getWalletHistory(userId: self.page.id, walletRequest: self.walletRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.history = (json[JsonKey.payload.rawValue].arrayValue).map { WalletHistory(json: $0) }
                    self.didGetWalletHistoryFinish?()
                } catch {
                    self.didError?()
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    var didGetWalletBalanceFinish: (() -> Void)?
    var didGetWalletHistoryFinish: (() -> Void)?
    var didError: (() -> Void)?
}

extension WalletViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .walletLookup {
            self.walletLookup()
        } else if self.state == .getWalletHistory {
            self.getWalletHistory()
        }
    }
}
