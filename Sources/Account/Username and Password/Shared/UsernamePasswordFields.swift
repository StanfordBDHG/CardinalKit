//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct UsernamePasswordFields: View {
    enum PresentationType {
        case login(ConfigurableLocalization<(
            username: FieldLocalization,
            password: FieldLocalization
        )>)
        // We do not introduce an explicit type for the temporary usage of the localization fields.
        // swiftlint:disable:next large_tuple
        case signUp(ConfigurableLocalization<(
            username: FieldLocalization,
            password: FieldLocalization,
            passwordRepeat: FieldLocalization,
            passwordNotEqualError: String
        )>)
        
        
        var login: Bool {
            if case .login = self {
                return true
            } else {
                return false
            }
        }
        
        var signUp: Bool {
            if case .signUp = self {
                return true
            } else {
                return false
            }
        }
        
        
        var username: FieldLocalization? {
            switch self {
            case let .login(.value((username, _))), let .signUp(.value((username, _, _, _))):
                return username
            default:
                return nil
            }
        }
        
        var password: FieldLocalization? {
            switch self {
            case let .login(.value((_, password))), let .signUp(.value((_, password, _, _))):
                return password
            default:
                return nil
            }
        }
        
        var passwordRepeat: FieldLocalization? {
            switch self {
            case let .signUp(.value((_, _, passwordRepeat, _))):
                return passwordRepeat
            default:
                return nil
            }
        }
        
        var passwordNotEqualError: String? {
            switch self {
            case let .signUp(.value((_, _, _, passwordNotEqualError))):
                return passwordNotEqualError
            default:
                return nil
            }
        }
    }
    
    
    private let usernameValidationRules: [ValidationRule]
    private let passwordValidationRules: [ValidationRule]
    private let presentationType: PresentationType
    
    @FocusState var focusedField: AccountInputFields?
    
    @EnvironmentObject private var usernamePasswordLoginService: UsernamePasswordAccountService
    
    @Binding private var valid: Bool
    @Binding private var username: String
    @Binding private var password: String
    
    @State private var passwordRepeat: String = ""
    
    @State private var usernameValid = false
    @State private var passwordValid = false
    @State private var passwordRepeatValid = false
    
    
    var body: some View {
        Group {
            usernameTextField
            Divider()
            passwordSecureField
            if presentationType.signUp {
                Divider()
                passwordRepeatSecureField
            }
        }
            .onChange(of: usernameValid) { _ in
                updateValid()
            }
            .onChange(of: passwordValid) { _ in
                updateValid()
            }
            .onChange(of: passwordRepeatValid) { _ in
                updateValid()
            }
            .onChange(of: password) { _ in
                updateValid()
            }
            .onChange(of: passwordRepeat) { _ in
                updateValid()
            }
    }
    
    private var usernameTextField: some View {
        let usernameLocalization: FieldLocalization
        if let username = presentationType.username {
            usernameLocalization = username
        } else {
            switch presentationType {
            case .login:
                usernameLocalization = usernamePasswordLoginService.localization.login.username
            case .signUp:
                usernameLocalization = usernamePasswordLoginService.localization.signUp.username
            }
        }
        
        return VerifiableTextFieldGridRow(
            text: $username,
            valid: $usernameValid,
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
    
    private var passwordSecureField: some View {
        let passwordLocalization: FieldLocalization
        if let password = presentationType.password {
            passwordLocalization = password
        } else {
            switch presentationType {
            case .login:
                passwordLocalization = usernamePasswordLoginService.localization.login.password
            case .signUp:
                passwordLocalization = usernamePasswordLoginService.localization.signUp.password
            }
        }
        
        return VerifiableTextFieldGridRow(
            text: $password,
            valid: $passwordValid,
            validationRules: passwordValidationRules,
            description: {
                Text(passwordLocalization.title)
            },
            textField: { binding in
                SecureField(text: binding) {
                    Text(passwordLocalization.placeholder)
                }
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(presentationType.login ? .password : .newPassword)
            }
        )
            .onTapFocus(focusedField: _focusedField, fieldIdentifier: .password)
    }
    
    private var passwordRepeatSecureField: some View {
        let passwordRepeatLocalization: FieldLocalization
        if let passwordRepeat = presentationType.passwordRepeat {
            passwordRepeatLocalization = passwordRepeat
        } else {
            switch presentationType {
            case .login:
                preconditionFailure("The password repeat field should never be shown in the login presentation type.")
            case .signUp:
                passwordRepeatLocalization = usernamePasswordLoginService.localization.signUp.passwordRepeat
            }
        }
        
        let passwordNotEqualErrorLocalization: String
        if let passwordNotEqualError = presentationType.passwordNotEqualError {
            passwordNotEqualErrorLocalization = passwordNotEqualError
        } else {
            switch presentationType {
            case .login:
                preconditionFailure("The password not equal error should never be shown in the login presentation type.")
            case .signUp:
                passwordNotEqualErrorLocalization = usernamePasswordLoginService.localization.signUp.passwordNotEqualError
            }
        }
        
        return VerifiableTextFieldGridRow(
            text: $passwordRepeat,
            valid: $passwordRepeatValid,
            validationRules: passwordValidationRules,
            description: {
                Text(passwordRepeatLocalization.title)
            },
            textField: { binding in
                VStack {
                    SecureField(text: binding) {
                        Text(passwordRepeatLocalization.placeholder)
                    }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .textContentType(.newPassword)
                    if password != passwordRepeat && !passwordRepeat.isEmpty {
                        HStack {
                            Text(passwordNotEqualErrorLocalization)
                                .fixedSize(horizontal: false, vertical: true)
                                .gridColumnAlignment(.leading)
                                .font(.footnote)
                                .foregroundColor(.red)
                            Spacer(minLength: 0)
                        }
                    }
                }
            }
        )
            .onTapFocus(focusedField: _focusedField, fieldIdentifier: .passwordRepeat)
    }
    
    
    init(
        username: Binding<String>,
        password: Binding<String>,
        valid: Binding<Bool>,
        focusState: FocusState<AccountInputFields?> = FocusState<AccountInputFields?>(),
        usernameValidationRules: [ValidationRule] = [],
        passwordValidationRules: [ValidationRule] = [],
        presentationType: PresentationType = .login(.environment)
    ) {
        self._username = username
        self._password = password
        self._valid = valid
        self._focusedField = focusState
        self.usernameValidationRules = usernameValidationRules
        self.passwordValidationRules = passwordValidationRules
        self.presentationType = presentationType
    }
    
    
    private func updateValid() {
        switch presentationType {
        case .login:
            valid = usernameValid && passwordValid
        case .signUp:
            valid = usernameValid
                && passwordValid
                && passwordRepeatValid
                && password == passwordRepeat
        }
    }
}


struct UsernamePasswordFields_Previews: PreviewProvider {
    @State private static var username: String = ""
    @State private static var password: String = ""
    @State private static var valid = false
    
    
    private static var validationRules: [ValidationRule] {
        guard let regex = try? Regex("[a-zA-Z]") else {
            return []
        }
        
        return [
            ValidationRule(
                regex: regex,
                message: "Validation failed: Required only letters."
            )
        ]
    }
    
    static var previews: some View {
        Form {
            Section {
                Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                    UsernamePasswordFields(
                        username: $username,
                        password: $password,
                        valid: $valid,
                        usernameValidationRules: validationRules,
                        passwordValidationRules: validationRules
                    )
                }
            }
            Section {
                Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                    UsernamePasswordFields(
                        username: $username,
                        password: $password,
                        valid: $valid,
                        usernameValidationRules: validationRules,
                        passwordValidationRules: validationRules,
                        presentationType: .signUp(.environment)
                    )
                }
            }
        }
            .environmentObject(UsernamePasswordAccountService())
    }
}
