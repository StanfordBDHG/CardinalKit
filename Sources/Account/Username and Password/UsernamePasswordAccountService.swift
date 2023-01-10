//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI


/// Account service that enables a username and password based management
///
/// The ``UsernamePasswordAccountService`` enables a username and password based account management.
///
/// Other ``AccountService``s can be created by subclassing the ``UsernamePasswordAccountService`` and overriding the ``UsernamePasswordAccountService/localization``,
/// buttons like the ``UsernamePasswordAccountService/loginButton``, or overriding the ``UsernamePasswordAccountService/login(username:password:)``
/// and ``UsernamePasswordAccountService/button(_:destination:)`` functions.
open class UsernamePasswordAccountService: @unchecked Sendable, AccountService, ObservableObject {
    /// The ``Account/Account`` instance that can be used to e.g., interact with the ``Account/Account/signedIn``.
    public weak var account: Account?
    
    
    /// The ``Localization`` used by the views presented in the ``UsernamePasswordAccountService`` or its subclasses.
    open var localization: Localization {
        Localization.default
    }
    
    /// The button that should be displayed in login-related views to represent the ``UsernamePasswordAccountService`` or its subclasses.
    open var loginButton: AnyView {
        button(localization.signUp.buttonTitle, destination: UsernamePasswordLoginView())
    }
    
    /// The button that should be displayed in sign up-related views to represent the ``UsernamePasswordAccountService`` or its subclasses.
    open var signUpButton: AnyView {
        button(localization.signUp.buttonTitle, destination: UsernamePasswordSignUpView())
    }
    
    /// The button that should be displayed in password-reset-related views to represent the ``UsernamePasswordAccountService`` or its subclasses.
    open var resetPasswordButton: AnyView {
        AnyView(
            NavigationLink {
                UsernamePasswordResetPasswordView {
                    processSuccessfulResetPasswordView
                }
                    .environmentObject(self as UsernamePasswordAccountService)
            } label: {
                Text(localization.resetPassword.buttonTitle)
            }
        )
    }
    
    open var processSuccessfulResetPasswordView: AnyView {
        AnyView(
            VStack(spacing: 32) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundColor(.green)
                    .frame(width: 100, height: 100)
                Text(localization.resetPassword.processSuccessfulLabel)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
                .padding(32)
        )
    }
    
    
    /// Creates a new instance of a ``UsernamePasswordAccountService``
    public init() { }
    
    
    public func inject(account: Account) {
        self.account = account
    }
    
    /// The function is called when a user is logged in.
    ///
    /// You can use views like the ``UsernamePasswordLoginView`` to display user interfaces for logging in users or create your own views and call ``UsernamePasswordAccountService/login(username:password:)``
    /// Throw an `Error` type conforming to `LocalizedError` if the sign up has not been successful to present a localized description to the user on a failed sign up.
    /// - Parameters:
    ///   - username: The username that should be used in the login process
    ///   - password: The password that should be used in the login process
    open func login(username: String, password: String) async throws { }
    
    
    /// The ``signUp(signUpValues:)`` method is called by UI elements when a user wants to sign up.
    ///
    /// You can use views like the ``UsernamePasswordSignUpView`` to display user interfaces for signing up users or create your own views and call ``UsernamePasswordAccountService/signUp(signUpValues:)``
    /// Throw an `Error` type conforming to `LocalizedError` if the sign up has not been successful to present a localized description to the user on a failed sign up.
    /// - Parameter signUpValues: The context collected in the sign in process. Refer to ``SignUpValues`` for more information about the possible context.
    open func signUp(signUpValues: SignUpValues) async throws { }
    
    
    /// The ``login(username:password:)`` method is called by UI elements when a user wants to reset their password.
    ///
    /// You can use views like the ``UsernamePasswordResetPasswordView`` to display user interfaces for resetting their password or create your own views and call ``UsernamePasswordAccountService/resetPassword(username:)``
    /// Throw an `Error` type conforming to `LocalizedError` if the reset password action has not been successful to present a localized description to the user on a failed reset password attempt.
    /// - Parameter username: The username that the password should be reset for.
    open func resetPassword(username: String) async throws { }
    
    
    /// Creates a resuable button styled in accordance to the ``UsernamePasswordAccountService`` or its subclasses.
    /// - Parameters:
    ///   - title: The title of the button.
    ///   - destination: The destination of the button.
    /// - Returns: Returns the styled button in accordance to the ``UsernamePasswordAccountService`` or its subclasses.
    open func button<V: View>(_ title: String, destination: V) -> AnyView {
        AnyView(
            NavigationLink {
                destination
                    .environmentObject(self as UsernamePasswordAccountService)
            } label: {
                AccountServiceButton {
                    Image(systemName: "ellipsis.rectangle")
                        .font(.title2)
                    Text(title)
                }
            }
        )
    }
}
