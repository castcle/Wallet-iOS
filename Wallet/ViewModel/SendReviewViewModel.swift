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
//  SendReviewViewModel.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 27/7/2565 BE.
//

import Core
import Networking
import SwiftyJSON

struct SendReview {
    let title: String
    let value: String
}

public final class SendReviewViewModel {

    private var walletRepository: WalletRepository = WalletRepositoryImpl()
    private var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var page: Page = Page()
    var walletRequest: WalletRequest = WalletRequest()
    var authenRequest: AuthenRequest = AuthenRequest()
    private var state: State = .none
    var sendReview: [SendReview] = []
    var isSendEmailOtp: Bool = false
    var isSendMobileOtp: Bool = false

    public init(walletRequest: WalletRequest = WalletRequest(), page: Page = Page()) {
        self.tokenHelper.delegate = self
        self.walletRequest = walletRequest
        self.page = page
        self.mappingUi()
    }

    private func mappingUi() {
        self.sendReview.append(SendReview(title: "Review send", value: "\(self.walletRequest.amount) CAST"))
        self.sendReview.append(SendReview(title: "Date", value: Date().dateToString()))
        self.sendReview.append(SendReview(title: "From", value: self.page.castcleId))
        self.sendReview.append(SendReview(title: "To Castcle ID", value: self.walletRequest.castcleId))
        self.sendReview.append(SendReview(title: "Coin", value: "CAST"))
        self.sendReview.append(SendReview(title: "Amount", value: "\(self.walletRequest.amount) CAST"))
        self.sendReview.append(SendReview(title: "Network fee", value: "0 CAST"))
    }

    func requestOtpWithMobile() {
        self.state = .requestOtpWithMobile
        self.isSendMobileOtp = false
        self.authenticationRepository.requestOtpWithMobile(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.walletRequest.mobileRefCode = json[JsonKey.refCode.rawValue].stringValue
                    self.walletRequest.countryCode = UserManager.shared.countryCode
                    self.walletRequest.mobileNumber = UserManager.shared.mobile
                    self.isSendMobileOtp = true
                    self.didRequestOtpFinish?()
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

    func requestOtpWithEmail() {
        self.state = .requestOtpWithEmail
        self.isSendEmailOtp = false
        self.authenticationRepository.requestOtpWithEmail(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.walletRequest.emailRefCode = json[JsonKey.refCode.rawValue].stringValue
                    self.walletRequest.email = UserManager.shared.email
                    self.isSendEmailOtp = true
                    self.didRequestOtpFinish?()
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

    func confirmSendToken() {
        self.state = .confirmSendToken
        self.walletRepository.confirmSendToken(userId: self.page.id, walletRequest: self.walletRequest) { (success, _, isRefreshToken) in
            if success {
                self.didSendTokenFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    var didRequestOtpFinish: (() -> Void)?
    var didSendTokenFinish: (() -> Void)?
    var didError: (() -> Void)?
}

extension SendReviewViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .requestOtpWithMobile {
            self.requestOtpWithMobile()
        } else if self.state == .requestOtpWithEmail {
            self.requestOtpWithEmail()
        }
    }
}
