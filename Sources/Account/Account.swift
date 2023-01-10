//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


/// Account-related CardinalKit module managing a collection of ``AccountService``s.
/// 
/// The ``Account/Account`` type also enables interaction with the ``AccountService``s from anywhere in the view hierachy.
public actor Account: ObservableObject {
    /// The ``Account/Account/signedIn`` determines if the the current Account context is signed in or not yet signed in.
    @MainActor @Published
    public var signedIn = false
    
    ///  An account provides a collection of ``AccountService``s that are used to populate login, sign up, or reset password screens.
    nonisolated let accountServices: [any AccountService]
    
    
    /// - Parameter accountServices: An account provides a collection of ``AccountService``s that are used to populate login, sign up, or reset password screens.
    public init(accountServices: [any AccountService]) {
        self.accountServices = accountServices
        for accountService in accountServices {
            accountService.inject(account: self)
        }
    }
}
