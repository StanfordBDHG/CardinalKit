//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Views


extension Localization {
    /// Provides localization information for the reset password-related views in the Accont module.
    ///
    /// The values passed into the ``Localization`` substructs are automatically interpreted according to the localization key mechanisms defined in the CardinalKit Views module.
    ///
    /// You can, e.g., only customize a specific value or all values that are available in the ``Localization/ResetPassword-swift.struct/init(buttonTitle:navigationTitle:username:resetPasswordActionButtonTitle:processSuccessfulLabel:defaultResetPasswordFailedError:)`` initializer.
    ///
    /// ```swift
    /// ResetPassword(
    ///     navigationTitle: "CUSTOM_NAVIGATION_TITLE",
    ///     username: FieldLocalization(
    ///        title: "CUSTOM_USERNAME",
    ///        placeholder: "CUSTOM_USERNAME_PLACEHOLDER"
    ///     )
    /// )
    /// ```
    public struct ResetPassword: Codable {
        /// A default configuration for providing localized text to reset password views
        public static let `default` = ResetPassword(
            buttonTitle: String(moduleLocalized: "UAP_RESET_PASSWORD_BUTTON_TITLE"),
            navigationTitle: String(moduleLocalized: "UAP_RESET_PASSWORD_NAVIGATION_TITLE"),
            username: FieldLocalization(
                title: String(moduleLocalized: "UAP_RESET_PASSWORD_USERNAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_RESET_PASSWORD_USERNAME_PLACEHOLDER")
            ),
            resetPasswordActionButtonTitle: String(moduleLocalized: "UAP_RESET_PASSWORD_ACTION_BUTTON_TITLE"),
            processSuccessfulLabel: String(moduleLocalized: "UAP_RESET_PASSWORD_PROCESS_SUCCESSFUL_LABEL"),
            defaultResetPasswordFailedError: String(moduleLocalized: "UAP_RESET_PASSWORD_FAILED_DEFAULT_ERROR")
        )
        
        
        /// A localized `String` to display on the reset password button.
        public let buttonTitle: String
        /// A localized `String` for the reset password view's navigation title.
        public let navigationTitle: String
        /// A `FieldLocalization` instance containing the localized title and placeholder text for the username field.
        public let username: FieldLocalization
        /// A localized `String` to display on the reset password action button.
        public let resetPasswordActionButtonTitle: String
        /// A localized `String` to display when the reset password process has been successful.
        public let processSuccessfulLabel: String
        /// A localized `String` to display when the reset password process has failed.
        public let defaultResetPasswordFailedError: String
        
        
        /// Creates a localization configuration for reset password views.
        ///
        /// - Parameters:
        ///   - buttonTitle: A localized `String` title for the reset password button.
        ///   - navigationTitle: A localized `String` for the reset password view's navigation title.
        ///   - username: A `FieldLocalization` instance containing the localized title and placeholder text for the username field.
        ///   - resetPasswordActionbuttonTitle: A localized `String` to display on the reset password action button.
        ///   - processSuccessfulLabel: A localized `String` to display when the reset password process has been successful.
        ///   - defaultResetPasswordFailedError: A localized `String` to display when the reset password process has failed.
        public init(
            buttonTitle: String = ResetPassword.default.buttonTitle,
            navigationTitle: String = ResetPassword.default.navigationTitle,
            username: FieldLocalization = ResetPassword.default.username,
            resetPasswordActionButtonTitle: String = ResetPassword.default.resetPasswordActionButtonTitle,
            processSuccessfulLabel: String = ResetPassword.default.processSuccessfulLabel,
            defaultResetPasswordFailedError: String = ResetPassword.default.defaultResetPasswordFailedError
        ) {
            self.buttonTitle = buttonTitle.localized
            self.navigationTitle = navigationTitle.localized
            self.username = username
            self.resetPasswordActionButtonTitle = resetPasswordActionButtonTitle.localized
            self.processSuccessfulLabel = processSuccessfulLabel.localized
            self.defaultResetPasswordFailedError = defaultResetPasswordFailedError.localized
        }
    }
}
