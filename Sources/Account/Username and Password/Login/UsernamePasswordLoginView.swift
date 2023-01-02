//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// A ``UsernamePasswordLoginView`` is a view that enables users to sign in with a username and password
/// using a ``UsernamePasswordAccountService`` passed as an EnvironmentObject. A header view, footer view,
/// localization, and validation rules for username and password can be optionally passed as arguments.
///
/// ```
/// UsernamePasswordLoginView(
///     usernameValidationRules: [/*..*/],
///     passwordValidationRules: [/*..*/],
///     header: HeaderView(),
///     footer: FooterView(),
///     localization: .environment
/// )
///     .environmentObject(UsernamePasswordAccountService())
/// ```
public struct UsernamePasswordLoginView: View {
    private let usernameValidationRules: [ValidationRule]
    private let passwordValidationRules: [ValidationRule]
    private let header: AnyView
    private let footer: AnyView
    
    @EnvironmentObject private var usernamePasswordAccountService: UsernamePasswordAccountService
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var valid = false
    @FocusState private var focusedField: AccountInputFields?
    
    private let localization: ConfigurableLocalization<Localization.Login>
    
    
    public var body: some View {
        ScrollView {
            DataEntryAccountView(
                buttonTitle: loginButtonTitleLocalization,
                defaultError: defaultLoginFailedError,
                focusState: _focusedField,
                valid: $valid,
                buttonPressed: {
                    try await usernamePasswordAccountService.login(username: username, password: password)
                },
                content: {
                    header
                    Divider()
                    usernamePasswordSection
                    Divider()
                    usernamePasswordAccountService.resetPasswordButton
                },
                footer: {
                    footer
                }
            )
            footer
        }
            .navigationTitle(navigationTitle)
    }
    
    private var usernamePasswordSection: some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 16) {
            switch localization {
            case .environment:
                UsernamePasswordFields(
                    username: $username,
                    password: $password,
                    valid: $valid,
                    focusState: _focusedField,
                    usernameValidationRules: usernameValidationRules,
                    passwordValidationRules: passwordValidationRules,
                    presentationType: .login(.environment)
                )
            case let .value(login):
                UsernamePasswordFields(
                    username: $username,
                    password: $password,
                    valid: $valid,
                    focusState: _focusedField,
                    usernameValidationRules: usernameValidationRules,
                    passwordValidationRules: passwordValidationRules,
                    presentationType: .login(
                        .value(
                            (
                                login.username,
                                login.password
                            )
                        )
                    )
                )
            }
        }
            .padding(.leading, 16)
            .padding(.vertical, 12)
    }
    
    private var loginButtonTitleLocalization: String {
        switch localization {
        case .environment:
            return usernamePasswordAccountService.localization.login.loginActionButtonTitle
        case let .value(login):
            return login.loginActionButtonTitle
        }
    }
    
    private var navigationTitle: String {
        switch localization {
        case .environment:
            return usernamePasswordAccountService.localization.login.navigationTitle
        case let .value(login):
            return login.navigationTitle
        }
    }
    
    private var defaultLoginFailedError: String {
        switch localization {
        case .environment:
            return usernamePasswordAccountService.localization.login.defaultLoginFailedError
        case let .value(resetPassword):
            return resetPassword.defaultLoginFailedError
        }
    }
    
    
    /// Creates a `UsernamePasswordLoginView` for users to log in with a username and password.
    ///
    /// - Parameters:
    ///   - usernameValidationRules: An array of ``ValidationRule``s to apply to the entered username
    ///   - passwordValidationRules: An array of ``ValidationRule``s to apply to the entered password
    ///   - header: A SwiftUI `View` to display as a header
    ///   - footer: A SwiftUI `View` to display as a footer
    ///   - localization: A localization configuration to apply to this view
    public init<Header: View, Footer: View>(
        usernameValidationRules: [ValidationRule] = [],
        passwordValidationRules: [ValidationRule] = [],
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder footer: () -> Footer = { EmptyView() },
        localization: ConfigurableLocalization<Localization.Login> = .environment
    ) {
        self.usernameValidationRules = usernameValidationRules
        self.passwordValidationRules = passwordValidationRules
        self.header = AnyView(header())
        self.footer = AnyView(footer())
        self.localization = localization
    }
}


struct UsernamePasswordLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UsernamePasswordLoginView()
                .environmentObject(UsernamePasswordAccountService())
        }
    }
}
