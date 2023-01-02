//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


/// A `UsernamePasswordResetPasswordView` is a view that enables users who have created an account
/// with a username and password to reset their password using a `UsernamePasswordAccountService`
/// passed as an EnvironmentObject.
///
/// If the password is successfully reset, the view passed into `processSuccessfulView` is shown.
/// A header view, footer view, and validation rules for the username can be optionally passed in as arguments.
///
/// ```
/// UsernamePasswordResetPasswordView(
///     usernameValidationRules: [/*..*/],
///     header: HeaderView(),
///     footer: FooterView(),
///     processSuccessfulView: ResetSuccessView(),
///     localization: .environment
/// )
///     .environmentObject(UsernamePasswordAccountService())
/// ``
public struct UsernamePasswordResetPasswordView: View {
    private let usernameValidationRules: [ValidationRule]
    private let header: AnyView
    private let footer: AnyView
    private let processSuccessfulView: AnyView
    
    @EnvironmentObject private var usernamePasswordAccountService: UsernamePasswordAccountService
    
    @State private var username: String = ""
    @State private var valid = false
    @State private var processSuccess = false
    @FocusState private var focusedField: AccountInputFields?
    
    private let localization: ConfigurableLocalization<Localization.ResetPassword>
    
    
    public var body: some View {
        ScrollView {
            if processSuccess {
                processSuccessfulView
            } else {
                DataEntryAccountView(
                    buttonTitle: resetPasswordButtonTitleLocalization,
                    defaultError: defaultResetPasswordFailedError,
                    focusState: _focusedField,
                    valid: $valid,
                    buttonPressed: {
                        try await usernamePasswordAccountService.resetPassword(username: username)
                        withAnimation(.easeOut(duration: 0.5)) {
                            processSuccess = true
                        }
                        try await Task.sleep(for: .seconds(0.6))
                    },
                    content: {
                        header
                        Divider()
                        usernameTextField
                        Divider()
                    },
                    footer: {
                        footer
                    }
                )
            }
        }
            .navigationTitle(navigationTitle)
    }
    
    private var usernameTextField: some View {
        let usernameLocalization: FieldLocalization
        switch localization {
        case .environment:
            usernameLocalization = usernamePasswordAccountService.localization.resetPassword.username
        case let .value(resetPassword):
            usernameLocalization = resetPassword.username
        }
        
        return Grid(horizontalSpacing: 16, verticalSpacing: 16) {
            VerifiableTextFieldGridRow(
                text: $username,
                valid: $valid,
                validationRules: usernameValidationRules,
                description: {
                    Text(usernameLocalization.title)
                },
                textField: { binding in
                    TextField(text: binding) {
                        Text(usernameLocalization.placeholder)
                    }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textContentType(.username)
                }
            )
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .username)
        }
            .padding(.leading, 16)
            .padding(.vertical, 12)
    }
    
    private var resetPasswordButtonTitleLocalization: String {
        switch localization {
        case .environment:
            return usernamePasswordAccountService.localization.resetPassword.resetPasswordActionButtonTitle
        case let .value(resetPassword):
            return resetPassword.resetPasswordActionButtonTitle
        }
    }
    
    private var navigationTitle: String {
        switch localization {
        case .environment:
            return usernamePasswordAccountService.localization.resetPassword.navigationTitle
        case let .value(resetPassword):
            return resetPassword.navigationTitle
        }
    }
    
    private var defaultResetPasswordFailedError: String {
        switch localization {
        case .environment:
            return usernamePasswordAccountService.localization.resetPassword.defaultResetPasswordFailedError
        case let .value(resetPassword):
            return resetPassword.defaultResetPasswordFailedError
        }
    }
    
    
    /// Creates a `UsernamePasswordResetPasswordView` for users who have created an account with
    /// a username and password to reset their password.
    ///
    /// - Parameters:
    ///   - usernameValidationRules: An array of ``ValidationRule``s to apply to the entered username
    ///   - header: A SwiftUI `View` to display as a header
    ///   - footer: A SwiftUI `View` to display as a footer
    ///   - processSuccessfulView: A SwiftUI `View` to display if the password has been successfully reset
    ///   - localization: A localization configuration  to apply to this view
    public init<Header: View, Footer: View, ProcessSuccessful: View>(
        usernameValidationRules: [ValidationRule] = [],
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder footer: () -> Footer = { EmptyView() },
        @ViewBuilder processSuccessfulView: () -> ProcessSuccessful,
        localization: ConfigurableLocalization<Localization.ResetPassword> = .environment
    ) {
        self.usernameValidationRules = usernameValidationRules
        self.header = AnyView(header())
        self.footer = AnyView(footer())
        self.processSuccessfulView = AnyView(processSuccessfulView())
        self.localization = localization
    }
}


struct UsernamePasswordResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UsernamePasswordResetPasswordView {
                Text("Sucessfully sent a link to reset the password ...")
            }
                .environmentObject(UsernamePasswordAccountService())
        }
    }
}
