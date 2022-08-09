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
    case text
}

public final class ScanQrCodeViewModel {

    var page: PageRealm = PageRealm()
    var chainId: String = ""
    var userId: String = ""
    var castcleId: String = ""
    var scanType: ScanType = .all
    var wallet: Wallet = Wallet()

    public init(scanType: ScanType = .all, page: PageRealm = PageRealm(), wallet: Wallet) {
        self.scanType = scanType
        self.page = page
        self.wallet = wallet
    }

    func isWalletData(value: String) -> Bool {
        return value.contains(Environment.qrCodeUrl)
    }

    func validateQrCode(value: String) {
        let data = value.replacingOccurrences(of: "\(Environment.qrCodeUrl)", with: "")
        self.checkWalletData(value: data)
    }

    func isCorrectWalletData(value: String) -> Bool {
        let data = value.replacingOccurrences(of: "\(Environment.qrCodeUrl)", with: "")
        let walletDataArr = data.components(separatedBy: "|")
        if walletDataArr.count == 3 {
            self.chainId = walletDataArr[0]
            self.userId = walletDataArr[1]
            self.castcleId = walletDataArr[2]
            return true
        } else {
            return false
        }
    }

    private func checkWalletData(value: String) {
        let walletDataArr = value.components(separatedBy: "|")
        if walletDataArr.count == 3 {
            self.chainId = walletDataArr[0]
            self.userId = walletDataArr[1]
            self.castcleId = walletDataArr[2]
            if self.scanType == .all {
                Utility.currentViewController().navigationController?.popViewController(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Utility.currentViewController().navigationController?.pushViewController(WalletOpener.open(.sendWallet(SendWalletViewModel(page: self.page, chainId: self.chainId, userId: self.userId, castcleId: self.castcleId, wallet: self.wallet))), animated: true)
                }
            }
        }
    }
}
