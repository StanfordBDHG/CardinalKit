//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Views


extension Localization {
    /// A configuration for providing localized text for login views
    ///
    /// ```
    /// Login(
    ///     buttonTitle: "Username and Password"
    ///     navigationTitle: "Login",
    ///     username: FieldLocalization(
    ///        title: "Username",
    ///        placeholder: "Enter your username ..."
    ///     ),
    ///     password: FieldLocalization(
    ///       title: "Password",
    ///       placeholder: "Enter your password ..."
    ///     ),
    ///     loginActionButtonTitle: "Login",
    ///     defaultLoginFailedError: "Could not login"
    /// )
    /// ```
    public struct Login: Codable {
        /// A default configuration for providing localized text to login views
        public static let `default` = Login(
            buttonTitle: String(moduleLocalized: "UAP_LOGIN_BUTTON_TITLE"),
            navigationTitle: String(moduleLocalized: "UAP_LOGIN_NAVIGATION_TITLE"),
            username: FieldLocalization(
                title: String(moduleLocalized: "UAP_LOGIN_USERNAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_LOGIN_USERNAME_PLACEHOLDER")
            ),
            password: FieldLocalization(
                title: String(moduleLocalized: "UAP_LOGIN_PASSWORD_TITLE"),
                placeholder: String(moduleLocalized: "UAP_LOGIN_PASSWORD_PLACEHOLDER")
            ),
            loginActionButtonTitle: String(moduleLocalized: "UAP_LOGIN_ACTION_BUTTON_TITLE"),
            defaultLoginFailedError: String(moduleLocalized: "UAP_LOGIN_FAILED_DEFAULT_ERROR")
        )
        
        
        /// A localized `String` to display on the login button
        public let buttonTitle: String
        /// A localized `String` for login view's navigation title
        public let navigationTitle: String
        /// A ``FieldLocalization`` instance containing the localized title and placeholder text for the username field
        public let username: FieldLocalization
        /// A  ``FieldLocalization`` instance containing the localized title and placeholder text for the password field
        public let password: FieldLocalization
        /// A localized `String` to display on the login action button
        public let loginActionButtonTitle: String
        /// A localized`String` error message to be displayed when login fails
        public let defaultLoginFailedError: String
        
        
        /// Creates a localization configuration for login views
        ///
        /// - Parameters:
        ///   - buttonTitle: A localized `String` to display on the login button
        ///   - navigationTitle: A localized `String` for the login view's navigation title
        ///   - username: A ``FieldLocalization`` instance containing the localized title and placeholder text for the username field
        ///   - password: A ``FieldLocalization`` instance containing the localized title and placeholder text for the password field
        ///   - loginActionButtonTitle: A localized `String` to display on the login action button
        ///   - defaultLoginFailedError: A localized `String` error message to be displayed when login fails
        public init(
            buttonTitle: String = Login.default.buttonTitle,
            navigationTitle: String = Login.default.navigationTitle,
            username: FieldLocalization = Login.default.username,
            password: FieldLocalization = Login.default.password,
            loginActionButtonTitle: String = Login.default.loginActionButtonTitle,
            defaultLoginFailedError: String = Login.default.defaultLoginFailedError
        ) {
            self.buttonTitle = buttonTitle.localized
            self.navigationTitle = navigationTitle.localized
            self.username = username
            self.password = password
            self.loginActionButtonTitle = loginActionButtonTitle.localized
            self.defaultLoginFailedError = defaultLoginFailedError.localized
        }
    }
}
