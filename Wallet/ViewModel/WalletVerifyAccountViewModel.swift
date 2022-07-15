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
//  WalletVerifyAccountViewModel.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 1/7/2565 BE.
//

import Core
import Networking
import SwiftyJSON

public enum VerifyAccountSection {
    case email
    case mobile

    public var text: String {
        switch self {
        case .email:
            return "Email"
        case .mobile:
            return "Mobile number"
        }
    }
}

public final class WalletVerifyAccountViewModel {

    private var userRepository: UserRepository = UserRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    let verifySection: [VerifyAccountSection] = [.email, .mobile]
    var state: State = .none

    public init() {
        self.tokenHelper.delegate = self
    }

    func getMe() {
        self.state = .getMe
        self.userRepository.getMe { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let user = UserInfo(json: json)
                    UserHelper.shared.updateLocalProfile(user: user)
                    self.didGetMeFinish?()
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

    func openSettingSection(section: VerifyAccountSection) {
        switch section {
        case .email:
            if UserManager.shared.email.isEmpty {
                NotificationCenter.default.post(name: .openRegisterEmailDelegate, object: nil, userInfo: nil)
            } else if !UserManager.shared.isVerifiedEmail {
                NotificationCenter.default.post(name: .openVerifyDelegate, object: nil, userInfo: nil)
            }
        case .mobile:
            if !UserManager.shared.isVerifiedMobile {
                NotificationCenter.default.post(name: .openVerifyMobileDelegate, object: nil, userInfo: nil)
            }
        }
    }

    var didGetMeFinish: (() -> Void)?
    var didError: (() -> Void)?
}

extension WalletVerifyAccountViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getMe {
            self.getMe()
        }
    }
}
