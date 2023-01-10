//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import Views


/// Defines the localization for the ``Account/Account`` module that can be used to customize the ``Account/Account`` module-related views.
///
/// The values passed into the ``Localization`` substructs are automatically interpreted according to the localization key mechanisms defined in the CardinalKit Views module.
///
/// The ``Localization`` initializer provides default values in localizations provided out-of-the-box by the ``Account/Account`` module.
/// Each substruct (``Localization/Login-swift.struct``, ``Localization/SignUp-swift.struct``, ``Localization/ResetPassword-swift.struct``) uses
/// these default values and can be customized by, e.g., only modifying a specific property:
/// ```swift
/// let localization = Localization(
///     login: Localization.Login(
///         navigationTitle: "CUSTOM_NAVIGATION_TITLE"
///     )
/// )
/// ```
public struct Localization: Codable {
    /// Defines the default localization.
    public static let `default` = Localization(
        login: Login.default,
        signUp: SignUp.default,
        resetPassword: ResetPassword.default
    )
    
    
    /// Localization for login views.
    public let login: Login
    /// Localization for sign up views.
    public let signUp: SignUp
    /// Localization for reset password views.
    public let resetPassword: ResetPassword
    
    
    /// Creates a new localization with configurations for login, sign up, and reset password views.
    ///
    /// - Parameters:
    ///   - login: An instance of ``Localization/Login-swift.struct``, a configuration for localizing login views.
    ///   - signUp: An instance of ``Localization/SignUp-swift.struct``, a configuration for localizing signup views.
    ///   - resetPassword: An instance of  ``Localization/ResetPassword-swift.struct``, a configuration for localizing reset password views.
    public init(
        login: Login = Localization.default.login,
        signUp: SignUp = Localization.default.signUp,
        resetPassword: ResetPassword = Localization.default.resetPassword
    ) {
        self.login = login
        self.signUp = signUp
        self.resetPassword = resetPassword
    }
}
