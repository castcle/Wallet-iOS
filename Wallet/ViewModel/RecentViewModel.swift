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
//  RecentViewModel.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 11/7/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public enum ResendType {
    case all
    case castcle
    case other
}

public final class RecentViewModel {

    private var walletRepository: WalletRepository = WalletRepositoryImpl()
    private var state: State = .none
    let tokenHelper: TokenHelper = TokenHelper()
    var castcle: [WalletsRecent] = []
    var other: [WalletsRecent] = []
    var searchCastcle: [WalletsRecent] = []
    var page: PageRealm = PageRealm()
    var isCastcleRecentExpand: Bool = false
    var isOtherRecentExpand: Bool = false
    var isSearch: Bool = false
    var isSearchCastcle: Bool = false
    var walletRequest: WalletRequest = WalletRequest()

    public init(page: PageRealm = PageRealm()) {
        self.tokenHelper.delegate = self
        self.page = page
    }

    func getWalletRecent() {
        self.state = .getWalletRecent
        self.walletRepository.getWalletRecent(userId: self.page.id) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.castcle = (json[JsonKey.castcle.rawValue].arrayValue).map { WalletsRecent(json: $0) }
                    self.other = (json[JsonKey.other.rawValue].arrayValue).map { WalletsRecent(json: $0) }
                    self.didGetWalletRecentFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    func walletSearch() {
        self.state = .walletSearch
        self.walletRepository.walletSearch(userId: self.page.id, walletRequest: self.walletRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.searchCastcle = (json[JsonKey.castcle.rawValue].arrayValue).map { WalletsRecent(json: $0) }
                    self.didGetWalletSearchFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    var didGetWalletRecentFinish: (() -> Void)?
    var didGetWalletSearchFinish: (() -> Void)?
}

extension RecentViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getWalletRecent {
            self.getWalletRecent()
        } else if self.state == .walletSearch {
            self.walletSearch()
        }
    }
}
