//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


/// Display login buttons for all configured ``AccountService``s using the ``Account/Account`` module.
///
/// The view displays a list of login buttons as well as a cusomizable header view that can be defined using the ``Login/init(header:)`` initializer.
public struct Login<Header: View>: View {
    private var header: Header
    
    
    public var body: some View {
        AccountServicesView(header: header) { accountService in
            accountService.loginButton
        }
            .navigationTitle(String(localized: "LOGIN", bundle: .module))
    }
    
    
    public init() where Header == EmptyView {
        self.header = EmptyView()
    }
    
    /// - Parameter header: A SwiftUI `View` displayed as a header above all login buttons.
    public init(header: Header) {
        self.header = header
    }
}


struct Login_Previews: PreviewProvider {
    @StateObject private static var account: Account = {
        let accountServices: [any AccountService] = [
            UsernamePasswordAccountService(),
            EmailPasswordAccountService()
        ]
        return Account(accountServices: accountServices)
    }()
    
    
    static var previews: some View {
        NavigationStack {
            Login()
        }
            .environmentObject(account)
    }
}
