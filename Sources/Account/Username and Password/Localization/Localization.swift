//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import Views


/// A `Localization` defines text that can be customized depending on the user's preferred language
public struct Localization: Codable {
    /// Defines the default localization
    public static let `default` = Localization(
        login: Login.default,
        signUp: SignUp.default,
        resetPassword: ResetPassword.default
    )
    
    
    /// Localization for login views
    public let login: Login
    /// Localization for signup views
    public let signUp: SignUp
    /// Localization for reset password views
    public let resetPassword: ResetPassword
    
    
    /// Creates a new localization with configurations for login, signup, and
    /// reset password views.
    ///
    /// - Parameters:
    ///   - login: An instance of ``Localization/Login-swift.struct``, a configuration for localizing login views
    ///   - signUp: An instance of ``Localization/SignUp-swift.struct``, a configuration for localizing signup views
    ///   - resetPassword: An instance of  ``Localization/ResetPassword-swift.struct``, a configuration for localizing reset password views
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
