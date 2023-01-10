//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Displays a login view allowing a user to enter a username and password.
///
/// Enables ``AccountService``s such as the ``UsernamePasswordAccountService`` to
/// display a user interface allowing users to login with a username and password.
///
/// The ``Login``  view automatically displays login buttons of all configured ``AccountService``s and is the recommended way to automatically constuct a login flow for different ``AccountService``s.
///
/// Nevertheless, the ``UsernamePasswordLoginView`` can also be used to display the login view in a custom login flow.
/// Applications must ensure that an ``UsernamePasswordAccountService`` instance is injected in the SwiftUI environment by, e.g., using the `.environmentObject(_:)` view modifier.
///
/// The view can automatically validate input using passed in ``ValidationRule``s and can be customized using header or footer views:
/// ```
/// UsernamePasswordLoginView(
///     passwordValidationRules: [
///         /* ... */
///     ],
///     header: {
///         Text("A Header View ...")
///     },
///     footer: {
///         Text("A Footer View ...")
///     }
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
    
    
    /// - Parameters:
    ///   - usernameValidationRules: An collection of ``ValidationRule``s to validate to the entered username.
    ///   - passwordValidationRules: An collection of ``ValidationRule``s to validate to the entered password.
    ///   - header: A SwiftUI `View` to display as a header.
    ///   - footer: A SwiftUI `View` to display as a footer.
    ///   - localization: A  ``ConfigurableLocalization`` to define the localization of the ``UsernamePasswordLoginView``. The default value uses the localization provided by the ``UsernamePasswordAccountService`` provided in the SwiftUI environment.
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
