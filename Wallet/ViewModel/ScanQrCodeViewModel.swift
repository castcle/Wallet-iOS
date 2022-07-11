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
//  ScanQrCodeViewModel.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 11/7/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public enum ScanType {
    case all
    case wallet
}

public final class ScanQrCodeViewModel {

//    private var walletRepository: WalletRepository = WalletRepositoryImpl()
//    private var state: State = .none
//    let tokenHelper: TokenHelper = TokenHelper()
//    var castcle: [WalletsRecent] = []
//    var other: [WalletsRecent] = []
//    var searchCastcle: [WalletsRecent] = []
    var page: Page = Page()
//    var isCastcleRecentExpand: Bool = false
//    var isOtherRecentExpand: Bool = false
//    var isSearch: Bool = false
//    var isSearchCastcle: Bool = false
//    var walletRequest: WalletRequest = WalletRequest()
    var scanType: ScanType = .all

    public init(scanType: ScanType = .all, page: Page = Page()) {
        self.scanType = scanType
        self.page = page
    }

    func isWalletData(value: String) -> Bool {
        return value.contains(Environment.qrCodeUrl)
    }

    func validateQrCode(value: String) {
        if value.contains(Environment.qrCodeUrl) {
            let data = value.replacingOccurrences(of: Environment.qrCodeUrl, with: "")
            self.checkWalletData(value: data)
        }
    }

    private func checkWalletData(value: String) {
        if value.contains("w/s/") {
            let walletData = value.replacingOccurrences(of: "w/s/", with: "")
            let walletDataArr = walletData.components(separatedBy: "|")
            if walletDataArr.count == 3 {
                let chainId: String = walletDataArr[0]
                let userId: String = walletDataArr[1]
                let castcleId: String = walletDataArr[2]
                if self.scanType == .all {
                    Utility.currentViewController().navigationController?.popViewController(animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        Utility.currentViewController().navigationController?.pushViewController(WalletOpener.open(.sendWallet(SendWalletViewModel(page: self.page, chainId: chainId, userId: userId, castcleId: castcleId))), animated: true)
                    }
                }
            }
        }
    }
}
