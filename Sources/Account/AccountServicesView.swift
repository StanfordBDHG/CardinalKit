//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


struct AccountServicesView<Header: View>: View {
    @EnvironmentObject var account: Account
    
    private var header: Header
    private var button: (any AccountService) -> AnyView
    
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                VStack {
                    header
                    Spacer(minLength: 0)
                    VStack(spacing: 16) {
                        ForEach(account.accountServices, id: \.id) { loginService in
                            button(loginService)
                        }
                    }
                        .padding(16)
                }
                    .frame(minHeight: proxy.size.height)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    
    init(button: @escaping (any AccountService) -> AnyView) where Header == EmptyView {
        self.header = EmptyView()
        self.button = button
    }
    
    init(header: Header, button: @escaping (any AccountService) -> AnyView) {
        self.header = header
        self.button = button
    }
}


struct AccountServicesView_Previews: PreviewProvider {
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
