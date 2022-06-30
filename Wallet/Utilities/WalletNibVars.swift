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
//  WalletNibVars.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 17/5/2565 BE.
//

public struct WalletNibVars {
    // MARK: - View Controller
    public struct ViewController {
        public static let wallet = "WalletViewController"
        public static let selectPage = "SelectPageViewController"
        public static let scanQrCode = "ScanQrCodeViewController"
        public static let myQrCode = "MyQrCodeViewController"
        public static let castcleQrCode = "CastcleQrCodeViewController"
        public static let otherChain = "OtherChainViewController"
        public static let selectNetwork = "SelectNetworkViewController"
        public static let sendWallet = "SendWalletViewController"
        public static let sendReview = "SendReviewViewController"
        public static let sendAuth = "SendAuthViewController"
        public static let verifyAccount = "WalletVerifyAccountViewController"
        public static let resend = "ResendViewController"
    }

    // MARK: - View
    public struct Storyboard {
        public static let wallet = "Wallet"
    }

    public struct View {
        public static let myQRCode = "MyQRCode"
        public static let otherChainQRCode = "OtherChainQRCode"
    }

    // MARK: - TableViewCell
    public struct TableViewCell {
        public static let displayName = "DisplayNameTableViewCell"
        public static let balance = "BalanceTableViewCell"
        public static let transaction = "TransactionTableViewCell"
        public static let banner = "BannerTableViewCell"
        public static let walletHistoryHeader = "WalletHistoryHeaderTableViewCell"
        public static let walletNoData = "WalletNoDataTableViewCell"
        public static let castcleQrCode = "CastcleQrCodeTableViewCell"
        public static let otherChain = "OtherChainTableViewCell"
        public static let memo = "MemoTableViewCell"
        public static let selectNetwork = "SelectNetworkTableViewCell"
        public static let sendShortcut = "SendShortcutTableViewCell"
        public static let sendTo = "SendToTableViewCell"
        public static let reviewSend = "ReviewSendTableViewCell"
        public static let reviewData = "ReviewDataTableViewCell"
        public static let sendConfiem = "SendConfiemTableViewCell"
        public static let sendVerify = "SendVerifyTableViewCell"
        public static let verifyAccount = "VerifyAccountTableViewCell"
        public static let notice = "NoticeTableViewCell"
        public static let resendUser = "ResendUserTableViewCell"
        public static let resendOther = "ResendOtherTableViewCell"
        public static let viewMore = "ViewMoreTableViewCell"
        public static let emptyData = "EmptyDataTableViewCell"
    }

    // MARK: - CollectionViewCell
    public struct CollectionViewCell {
        public static let shortcut = "ShortcutCollectionViewCell"
    }
}
