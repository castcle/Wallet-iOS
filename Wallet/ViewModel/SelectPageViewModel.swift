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
//  SelectPageViewModel.swift
//  Wallet
//
//  Created by Castcle Co., Ltd. on 17/5/2565 BE.
//

import Core
import RealmSwift

public final class SelectPageViewModel {
    var pages: [PageRealm] = []
    var selectPage: PageRealm = PageRealm()
    var enableCancel: Bool = false

    public init(selectPage: PageRealm = PageRealm(), enableCancel: Bool = false) {
        self.selectPage = selectPage
        self.enableCancel = enableCancel
        self.pages.append(PageRealm().initCustom(id: UserManager.shared.id, displayName: UserManager.shared.displayName, castcleId: UserManager.shared.castcleId, avatar: UserManager.shared.avatar, cover: UserManager.shared.cover, overview: UserManager.shared.overview, official: UserManager.shared.official))
        do {
            let realm = try Realm()
            let pageLocal = realm.objects(PageRealm.self).sorted(byKeyPath: "id")
            self.pages.append(contentsOf: pageLocal)
        } catch {}
    }
}
