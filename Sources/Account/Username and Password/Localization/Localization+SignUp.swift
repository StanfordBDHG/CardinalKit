//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Views


extension Localization {
    /// Provides localization information for the sign up-related views in the Accont module.
    ///
    /// The values passed into the ``Localization`` substructs are automatically interpreted according to the localization key mechanisms defined in the CardinalKit Views module.
    ///
    /// You can, e.g., only customize a specific value or all values that are available in the ``Localization/SignUp-swift.struct/init(buttonTitle:navigationTitle:username:password:passwordRepeat:passwordNotEqualError:givenName:familyName:genderIdentityTitle:dateOfBirthTitle:signUpActionButtonTitle:defaultSignUpFailedError:)`` initializer.
    ///
    /// ```swift
    /// SignUp(
    ///     navigationTitle: "CUSTOM_NAVIGATION_TITLE",
    ///     username: FieldLocalization(
    ///        title: "CUSTOM_USERNAME",
    ///        placeholder: "CUSTOM_USERNAME_PLACEHOLDER"
    ///     )
    /// )
    /// ```
    public struct SignUp: Codable {
        /// A default configuration for providing localized text to sign up views.
        public static let `default` = SignUp(
            buttonTitle: String(moduleLocalized: "UAP_SIGNUP_BUTTION_TITLE"),
            navigationTitle: String(moduleLocalized: "UAP_SIGNUP_NAVIGATION_TITLE"),
            username: FieldLocalization(
                title: String(moduleLocalized: "UAP_SIGNUP_USERNAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_USERNAME_PLACEHOLDER")
            ),
            password: FieldLocalization(
                title: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_PLACEHOLDER")
            ),
            passwordRepeat: FieldLocalization(
                title: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_REPEAT_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_REPEAT_PLACEHOLDER")
            ),
            passwordNotEqualError: String(moduleLocalized: "UAP_SIGNUP_PASSWORD_NOT_EQUAL_ERROR"),
            givenName: FieldLocalization(
                title: String(moduleLocalized: "UAP_SIGNUP_GIVEN_NAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_GIVEN_NAME_PLACEHOLDER")
            ),
            familyName: FieldLocalization(
                title: String(moduleLocalized: "UAP_SIGNUP_FAMILY_NAME_TITLE"),
                placeholder: String(moduleLocalized: "UAP_SIGNUP_FAMILY_NAME_PLACEHOLDER")
            ),
            genderIdentityTitle: String(moduleLocalized: "UAP_SIGNUP_GENDER_IDENTITY_TITLE"),
            dateOfBirthTitle: String(moduleLocalized: "UAP_SIGNUP_DATE_OF_BIRTH_TITLE"),
            signUpActionButtonTitle: String(moduleLocalized: "UAP_SIGNUP_ACTION_BUTTON_TITLE"),
            defaultSignUpFailedError: String(moduleLocalized: "UAP_SIGNUP_FAILED_DEFAULT_ERROR")
        )
        
        
        /// A localized `String` to display on the sign up button.
        public let buttonTitle: String
        /// A localized `String` for sign up view's localized navigation title.
        public let navigationTitle: String
        /// A `FieldLocalization` instance containing the localized title and placeholder text for the username field.
        public let username: FieldLocalization
        /// A  `FieldLocalization` instance containing the localized title and placeholder text for the password field.
        public let password: FieldLocalization
        /// A  `FieldLocalization` instance containing the localized title and placeholder text for the password repeat field.
        public let passwordRepeat: FieldLocalization
        /// A localized`String` error message to be displayed when the text in the password and password repeat fields are not equal.
        public let passwordNotEqualError: String
        /// A `FieldLocalization` instance containing the localized title and placeholder text for the given name (first name) field.
        public let givenName: FieldLocalization
        /// A `FieldLocalization` instance containing the localized title and placeholder text for the family name (last name) field.
        public let familyName: FieldLocalization
        /// A localized `String` label for the gender identity field.
        public let genderIdentityTitle: String
        /// A localized `String` label for the date of birth field.
        public let dateOfBirthTitle: String
        /// A localized `String` title for the sign up action button.
        public let signUpActionButtonTitle: String
        /// A localized `String` message to display when sign up fails.
        public let defaultSignUpFailedError: String
        
        
        /// Creates a localization configuration for signup views.
        ///
        /// - Parameters:
        ///   - buttonTitle: A localized `String` to display on the sign up button.
        ///   - navigationTitle: A localized `String` for sign up view's localized navigation title.
        ///   - username: A `FieldLocalization` instance containing the localized title and placeholder text for the username field.
        ///   - password: A  `FieldLocalization` instance containing the localized title and placeholder text for the password field.
        ///   - passwordRepeat: A  `FieldLocalization` instance containing the localized title and placeholder text for the password repeat field.
        ///   - passwordNotEqualError: A localized`String` error message to be displayed when the text in the password and password repeat fields are not equal.
        ///   - givenName: A `FieldLocalization` instance containing the localized title and placeholder text for the given name (first name) field.
        ///   - familyName: A `FieldLocalization` instance containing the localized title and placeholder text for the family name (last name) field.
        ///   - genderIdentityTitle: A localized `String` label for the gender identity field.
        ///   - dateOfBirthTitle: A localized `String` label for the date of birth field.
        ///   - signUpActionButtonTitle: A localized `String` title for the sign up action button.
        ///   - defaultSignUpFailedError: A localized `String` message to display when sign up fails.
        public init(
            buttonTitle: String = SignUp.default.buttonTitle,
            navigationTitle: String = SignUp.default.navigationTitle,
            username: FieldLocalization = SignUp.default.username,
            password: FieldLocalization = SignUp.default.password,
            passwordRepeat: FieldLocalization = SignUp.default.passwordRepeat,
            passwordNotEqualError: String = SignUp.default.passwordNotEqualError,
            givenName: FieldLocalization = SignUp.default.givenName,
            familyName: FieldLocalization = SignUp.default.familyName,
            genderIdentityTitle: String = SignUp.default.genderIdentityTitle,
            dateOfBirthTitle: String = SignUp.default.dateOfBirthTitle,
            signUpActionButtonTitle: String = SignUp.default.signUpActionButtonTitle,
            defaultSignUpFailedError: String = SignUp.default.defaultSignUpFailedError
        ) {
            self.buttonTitle = buttonTitle.localized
            self.navigationTitle = navigationTitle.localized
            self.username = username
            self.password = password
            self.passwordRepeat = passwordRepeat
            self.passwordNotEqualError = passwordNotEqualError.localized
            self.givenName = givenName
            self.familyName = familyName
            self.genderIdentityTitle = genderIdentityTitle.localized
            self.dateOfBirthTitle = dateOfBirthTitle.localized
            self.signUpActionButtonTitle = signUpActionButtonTitle.localized
            self.defaultSignUpFailedError = defaultSignUpFailedError.localized
        }
    }
}
