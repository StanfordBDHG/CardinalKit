//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views

/// Displays a reset password view allowing a user to enter a username.
///
/// Enables ``AccountService``s such as the ``UsernamePasswordAccountService`` to
/// display a user interface allowing users to start the reset password workflow.
///
/// If the password is successfully reset, the view passed as the `processSuccessfulView` into the ``UsernamePasswordResetPasswordView/init(usernameValidationRules:header:footer:processSuccessfulView:localization:)`` initializer is displayed.
///
/// Applications must ensure that an ``UsernamePasswordAccountService`` instance is injected in the SwiftUI environment by, e.g., using the `.environmentObject(_:)` view modifier.
///
/// The view can automatically validate input using passed in ``ValidationRule``s and can be customized using header or footer views:
/// ```
/// UsernamePasswordResetPasswordView(
///     usernameValidationRules: [
///         /* ... */
///     ],
///     header: {
///         Text("A Header View ...")
///     },
///     footer: {
///         Text("A Header View ...")
///     },
///     processSuccessfulView: {
///         Text("The an email to reset the password has been sent out.")
///     }
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
    
    
    /// - Parameters:
    ///   - usernameValidationRules: An collection of ``ValidationRule``s to validete the entered username.
    ///   - header: A SwiftUI `View` to display as a header.
    ///   - footer: A SwiftUI `View` to display as a footer.
    ///   - processSuccessfulView: A SwiftUI `View` to display if the password has been successfully reset.
    ///   - localization: A  ``ConfigurableLocalization`` to define the localization of the ``UsernamePasswordResetPasswordView``. The default value uses the localization provided by the ``UsernamePasswordAccountService`` provided in the SwiftUI environment.
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
