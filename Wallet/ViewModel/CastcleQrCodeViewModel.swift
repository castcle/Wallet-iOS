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
//  CastcleQrCodeViewModel.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 9/6/2565 BE.
//

import Core
import Networking
import SwiftyJSON
import UIKit

public final class CastcleQrCodeViewModel {
    private var walletRepository: WalletRepository = WalletRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var walletRequest: WalletRequest = WalletRequest()
    var qrCodeImage: UIImage?

    public init() {
        self.tokenHelper.delegate = self
    }

    func getQrCode() {
        self.walletRepository.getQrCode(chainId: "castcle", userId: UserManager.shared.castcleId, walletRequest: self.walletRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let payload: String = json[JsonKey.payload.rawValue].stringValue
                    let qrCodeBase64String: String = payload.replacingOccurrences(of: "data:image/png;base64,", with: "")
                    self.qrCodeImage = qrCodeBase64String.imageFromBase64
                    self.didGetQrCodeFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    var didGetQrCodeFinish: (() -> Void)?
}

extension CastcleQrCodeViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        self.getQrCode()
    }
}
