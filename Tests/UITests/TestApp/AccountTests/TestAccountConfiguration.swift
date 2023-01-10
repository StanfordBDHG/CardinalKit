//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import Account
import CardinalKit
import Foundation


final class TestAccountConfiguration<ComponentStandard: Standard>: Component, ObservableObjectProvider {
    private let account: Account
    private let user: User
    
    
    var observableObjects: [any ObservableObject] {
        [
            account,
            user
        ]
    }
    
    
    init() {
        self.user = User()
        let accountServices: [any AccountService] = [
            MockUsernamePasswordAccountService(user: user),
            MockEmailPasswordAccountService(user: user)
        ]
        self.account = Account(accountServices: accountServices)
    }
}
